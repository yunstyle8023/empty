//
//  CA_MDiscoverSponsorItemInvestViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemInvestViewModel.h"
#import "CA_MDiscoverSponsorItemInvestModel.h"

@interface CA_MDiscoverSponsorItemInvestViewModel ()

@property (nonatomic,strong) CA_MDiscoverSponsorItemInvestRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@end

@implementation CA_MDiscoverSponsorItemInvestViewModel

-(NSString *)title{
    return @"投资基金";
}

-(CA_MDiscoverSponsorItemInvestRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverSponsorItemInvestRequestModel new];
        _requestModel.data_type = @"invest_fund";
        _requestModel.lp_id = self.lpId;
        _requestModel.page_size = @20;
        _requestModel.page_num = @1;
    }
    return _requestModel;
}

-(CA_MDiscoverSponsorItemInvestModel *)listModel{
    if (!_listModel) {
        _listModel = [CA_MDiscoverSponsorItemInvestModel new];
        [CA_HProgressHUD loading:self.loadingView];
        self.loadDataBlock();
    }
    return _listModel;
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
    [CA_HNetManager postUrlStr:CA_M_LpDetailDataList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) {
            [CA_HProgressHUD hideHud:self.loadingView];
        }
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    CA_MDiscoverSponsorItemInvestModel *listModel =  [CA_MDiscoverSponsorItemInvestModel modelWithDictionary:netModel.data];
                    if (listModel) {
                        if (!self.isLoadMore) {
                            self.listModel = listModel;
                        }else {
                            [self.listModel.data_list addObjectsFromArray:listModel.data_list];
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
            BOOL isHasData = (self.requestModel.page_num.intValue != self.listModel.total_page.intValue)
            &&
            (self.listModel.total_page);
            self.finishedBlock(self.isLoadMore, isHasData);
        }
        
    } progress:nil];
}
@end
