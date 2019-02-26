
//
//  CA_MDiscoverInvestmentManageFoundsViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsViewModel.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"

@interface CA_MDiscoverInvestmentManageFoundsViewModel ()
@property (nonatomic,strong) CA_MDiscoverInvestmentRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end

@implementation CA_MDiscoverInvestmentManageFoundsViewModel

-(NSString *)title{
    if ([self.data_type isEqualToString:@"managed_fund"]) {//管理基金
        return @"管理基金";
    }else if ([self.data_type isEqualToString:@"foreign_investment_fund"]) {//对外投资基金
        return @"对外投资基金";
    }else if ([self.data_type isEqualToString:@"undisclosed_investment"]) {//未公开投资事件
        return @"未公开投资事件";
    }else if ([self.data_type isEqualToString:@"public_investment_event"]) {//公开投资事件
        return @"公开投资事件";
    }
    return @"";
}

-(CA_MDiscoverInvestmentRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverInvestmentRequestModel new];
        _requestModel.data_type = self.data_type;
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
                            
                            if ([self.data_type isEqualToString:@"managed_fund"]) {//管理基金
                                CA_MDiscoverInvestmentManaged_FundModel *model = [CA_MDiscoverInvestmentManaged_FundModel modelWithDictionary:dic];
                                [self.dataSource addObject:model];
                            }else if ([self.data_type isEqualToString:@"foreign_investment_fund"]//对外投资基金
                                      ||
                                      [self.data_type isEqualToString:@"undisclosed_investment"]) {//未公开投资事件
                                CA_MDiscoverInvestmentInvestment_FundModel *model = [CA_MDiscoverInvestmentInvestment_FundModel modelWithDictionary:dic];
                                [self.dataSource addObject:model];
                            }else if ([self.data_type isEqualToString:@"public_investment_event"]) {//公开投资事件
                                CA_MDiscoverInvestmentPublic_Investment_EventdModel *model = [CA_MDiscoverInvestmentPublic_Investment_EventdModel modelWithDictionary:dic];
                                [self.dataSource addObject:model];
                            }

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
