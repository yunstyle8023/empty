//
//  CA_HForeignInvestmentModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HForeignInvestmentModelManager.h"

@interface CA_HForeignInvestmentModelManager ()

@end

@implementation CA_HForeignInvestmentModelManager {
    NSURLSessionDataTask *_dataTask;
}

#pragma mark --- Action

#pragma mark --- Lazy

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadMore:(NSNumber *)pageNum {
    
    if (!pageNum) self.finishBlock(NO);
    
    NSDictionary *parameters =
    @{@"data_type": @"investevent",
      @"search_str": self.searchStr?:@"",
      @"search_type": @"keyword",
      @"page_size": @(20),
      @"page_num": pageNum};
    
    [_dataTask cancel];
    
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager postUrlStr:CA_M_SearchDataList parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                
                CA_HInvestEventModel *model = [CA_HInvestEventModel modelWithDictionary:netModel.data];
                self.model = model;
                
                BOOL set = NO;
                if (model.page_num.integerValue) {
                    set = (model.page_num.integerValue >= model.total_page.integerValue);
                }
                if (model.page_num.integerValue == 1) {
                    [self.data removeAllObjects];
                }
                [self.data addObjectsFromArray:model.data_list];
                
                if (self.finishBlock) self.finishBlock(set);
                return;
            }
        }
        
        if (self.finishBlock) self.finishBlock(NO);
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

#pragma mark --- Delegate

@end
