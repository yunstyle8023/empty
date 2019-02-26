
//
//  CA_MDiscoverInvestmentViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentViewModel.h"
#import "CA_MDiscoverModel.h"
#import "CA_MDiscoverInvestmentModel.h"

@interface CA_MDiscoverInvestmentViewModel ()
@property (nonatomic,strong) CA_MDiscoverRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end

@implementation CA_MDiscoverInvestmentViewModel

-(NSString *)title{
    return @"查找投资机构";
}

-(CA_MDiscoverRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverRequestModel new];
        _requestModel.data_type = self.data_type;
        _requestModel.search_str = [NSString isValueableString:self.search_str]?self.search_str:@"latest";
        _requestModel.search_type = [NSString isValueableString:self.search_type]?self.search_type:@"latest";
        _requestModel.page_size = @20;
        _requestModel.page_num = @1;
    }
    return _requestModel;
}

-(void)setSearch_str:(NSString *)search_str{
    _search_str = search_str;
    _requestModel.search_str = search_str;
}

-(CA_MDiscoverInvestmentModel *)investmentModel{
    if (!_investmentModel) {
        _investmentModel = [CA_MDiscoverInvestmentModel new];
        self.loadDataBlock();
    }
    return _investmentModel;
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
    if (self.isFilter) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_M_SearchDataList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        
        self.filter = NO;
        
        if (self.loadingView) {
            [CA_HProgressHUD hideHud:self.loadingView];
        }
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    CA_MDiscoverInvestmentModel *investmentModel =  [CA_MDiscoverInvestmentModel modelWithDictionary:netModel.data];
                    if (investmentModel) {
                        if (!self.isLoadMore) {
                            self.investmentModel = investmentModel;
                        }else {
                            [self.investmentModel.data_list addObjectsFromArray:investmentModel.data_list];
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
            BOOL isHasData = (self.requestModel.page_num.intValue != self.investmentModel.total_page.intValue)
            &&
            (self.investmentModel.total_page);
            self.finishedBlock(self.isLoadMore, isHasData);
        }
        
    } progress:nil];
}

-(void)loadFilterData:(void(^)(CA_MDiscoverInvestmentFilterData *filterData))block{
    [CA_HNetManager postUrlStr:CA_M_QueryFilterResult parameters:@{@"data_type":@"gp"} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                CA_MDiscoverInvestmentFilterData *filterData= [CA_MDiscoverInvestmentFilterData modelWithDictionary:netModel.data];
                if (filterData) {
                    block?block(filterData):nil;
                }
            }
        }
    } progress:nil];
}

@end
