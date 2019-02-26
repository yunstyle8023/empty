
//
//  CA_MDiscoverInvestmentCommerceViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentCommerceViewModel.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"

@interface CA_MDiscoverInvestmentCommerceViewModel ()
@property (nonatomic,strong) CA_MDiscoverInvestmentRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end

@implementation CA_MDiscoverInvestmentCommerceViewModel

-(NSString *)title{
    return @"工商追踪";
}

-(CA_MDiscoverInvestmentRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverInvestmentRequestModel new];
        _requestModel.data_type = @"business_trace";
        _requestModel.gp_id = self.gp_id;
        _requestModel.page_num = @1;
        _requestModel.page_size = @20;
    }
    return _requestModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        self.loadDataBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return  ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @1;
        [self.dataSource removeAllObjects];
        self.loadMore = NO;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @(self.requestModel.page_num.intValue + 1);
        self.loadMore = YES;
        [self requestData];
    };
}

-(void)requestData{
    __block BOOL isAdd = YES;
    if (self.loadingView) {
        [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_H_Api_GpDetailDataList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]]
                        &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        
                        for (NSDictionary *dic in netModel.data[@"data_list"]) {
                            CA_MDiscoverInvestmentBusiness_TraceModel *model = [CA_MDiscoverInvestmentBusiness_TraceModel modelWithDictionary:dic];
                            [self.dataSource addObject:model];
                        }
                        //
                        isAdd = NO;
                    }
                }
            }
        }
        
        if (isAdd && self.isLoadMore) {//请求失败页数减1
            self.requestModel.page_num = @(self.requestModel.page_num.intValue - 1);
        }
        
        if (self.finishedBlock) {
            BOOL isHasData = (self.requestModel.page_num.intValue == [netModel.data[@"total_page"] intValue]);
            self.finishedBlock(self.isLoadMore, isHasData);
        }
    } progress:nil];
}

@end
