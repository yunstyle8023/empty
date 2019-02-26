//
//  CA_HSearchReportModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSearchReportModelManager.h"

@interface CA_HSearchReportModelManager ()

@end

@implementation CA_HSearchReportModelManager{
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

- (NSString *)headerText {
    
    NSInteger count = [self.model total_count].integerValue;
    
    NSString *str = count>1000?@"1000+":[NSString stringWithFormat:@"%ld", count];
    
    return [NSString stringWithFormat:@"<font color='#999999'>搜索到</font><font color='#5E69C7'> %@ </font><font color='#999999'>篇报告</font>", str];
}

- (void)setSearchText:(NSString *)searchText {
    if (searchText.length > 1) {
        if (![searchText isEqualToString:_searchText]) {
            _searchText = searchText;
            [self loadMore:@(1)];
        }
    } else {
        _searchText = nil;
        [self.data removeAllObjects];
        [_dataTask cancel];
        if (self.finishBlock) self.finishBlock(NO);
    }
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadMore:(NSNumber *)pageNum {
    
    if (!pageNum) self.finishBlock(NO);
    
    NSDictionary *parameters =
    @{@"search_str": self.searchText?:@"",
      @"data_type": self.dataType?:@"",
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
                
                CA_HFoundReportModel *model = [CA_HFoundReportModel modelWithDictionary:netModel.data];
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
        
        if (self.finishBlock) self.finishBlock(YES);
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}


@end
