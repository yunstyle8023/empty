//
//  CA_MDiscoverGovernmentFundsViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverGovernmentFundsViewModel.h"
#import "CA_MDiscoverSponsorModel.h"
#import "CA_MDiscoverModel.h"

@interface CA_MDiscoverGovernmentFundsViewModel ()

@property (nonatomic,strong) CA_MDiscoverSponsorRequestModel *requestModel;

@end

@implementation CA_MDiscoverGovernmentFundsViewModel

-(NSString *)title{
    return @"政府引导基金";
}

-(CA_MDiscoverSponsorRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverSponsorRequestModel new];
        _requestModel.data_type = self.data_type;
        _requestModel.search_type = self.search_type;
        _requestModel.page_num = @1;
        _requestModel.page_size = @20;
    }
    return _requestModel;
}

-(void)setSearch_type:(NSString *)search_type{
    _search_type = search_type;
    self.requestModel.search_type = self.search_type;
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
        self.finished = NO;
        self.showLoading = YES;
        self.requestModel.page_num = @1;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return  ^{
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.finished = NO;
        self.showLoading = NO;
        self.requestModel.page_num = @1;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.loadMore = YES;
        self.finished = NO;
        self.showLoading = NO;
        self.requestModel.page_num = @(self.requestModel.page_num.intValue + 1);
        [self requestData];
    };
}

-(void)requestData{
    
    if (self.isShowLoading) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_M_ListInvestorRecommend parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        
        self.finished = YES;
        
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    self.total_count = netModel.data[@"total_count"];
                    
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]]
                        &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        
                        if (!self.isLoadMore) {
                            [self.dataSource removeAllObjects];
                        }
                        
                        for (NSDictionary *dic in netModel.data[@"data_list"]) {
                            [self.dataSource addObject:[CA_MDiscoverSponsorData_list modelWithDictionary:dic]];
                        }
                        
                        BOOL isHasData = (self.requestModel.page_num.intValue < [netModel.data[@"page_count"] intValue]);
                        self.finishedBlock?self.finishedBlock(self.isLoadMore, isHasData):nil;
                        
                        return ;
                    }
                }
            }
        }
        
        if (self.isLoadMore) {//请求失败页数减1
            self.requestModel.page_num = @(self.requestModel.page_num.intValue - 1);
        }
        
        self.finishedBlock?self.finishedBlock(self.isLoadMore, NO):nil;

    } progress:nil];
}

@end






