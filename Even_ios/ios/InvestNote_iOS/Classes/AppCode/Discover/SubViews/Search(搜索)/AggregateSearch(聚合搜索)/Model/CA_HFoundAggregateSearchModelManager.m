//
//  CA_HFoundAggregateSearchModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundAggregateSearchModelManager.h"

@interface CA_HFoundAggregateSearchModelManager ()

@end

@implementation CA_HFoundAggregateSearchModelManager{
    NSURLSessionDataTask *_dataTask;
}

#pragma mark --- Action

#pragma mark --- Lazy

- (NSArray *)recentSearch {
    return [CA_H_UserDefaults objectForKey:CA_H_FoundSearchHistoryAggregate];
}

- (NSArray *)recentBrowse {
    return [CA_H_UserDefaults objectForKey:CA_H_FoundBrowseHistoryAggregate];
}

- (void)setSearchText:(NSString *)searchText {
    if (searchText.length > 1) {
        if (![searchText isEqualToString:_searchText]) {
            _searchText = searchText;
            [self loadMore];
        }
    } else {
        _searchText = nil;
        [_dataTask cancel];
        self.model = nil;
        if (self.finishBlock) self.finishBlock();
    }
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (NSArray *)data:(NSInteger)section {
    switch (section) {
        case 0:
            return self.model.project_data.data_list;
        case 1:
            return self.model.enterprise_data.data_list;
        case 2:
            return self.model.lp_data.data_list;
        case 3:
            return self.model.gp_data.data_list;
        default:
            return @[];
    }
}

- (NSString *)count:(NSInteger)section {
    NSString *str = @"0";
    switch (section) {
        case 0:
            str = self.model.project_data.total_count.stringValue;
            break;
        case 1:
            str = self.model.enterprise_data.total_count.stringValue;
            break;
        case 2:
            str = self.model.lp_data.total_count.stringValue;
            break;
        case 3:
            str = self.model.gp_data.total_count.stringValue;
            break;
        default:
            break;
    }
    if (str.integerValue > 1000) {
        return @"1000+";
    } else {
        return str;
    }
}

- (NSString *)headerTitle:(NSInteger)section {
    switch (section) {
        case 0:
            return @"项目";
        case 1:
            return @"企业";
        case 2:
            return @"出资人";
        case 3:
            return @"投资机构";
        default:
            return @"";
    }
}

- (void)loadMore {
    
    NSDictionary *parameters =
    @{@"data_type": @"aggregation",
      @"search_str": self.searchText?:@"",
      @"search_type": @"keyword",
      @"page_size": @(3),
      @"page_num": @(1)};
    
    [_dataTask cancel];
    
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager postUrlStr:CA_M_SearchDataList parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                
                self.model = [CA_HFoundSearchAggregationModel modelWithDictionary:netModel.data];
                
                if (self.finishBlock) self.finishBlock();
                return;
            }
        }
        
        if (self.finishBlock) self.finishBlock();
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

- (void)saveSearch:(NSString *)text {
    [self saveHistory:text key:CA_H_FoundSearchHistoryAggregate];
}

- (void)saveBrowse:(NSDictionary *)dic {
    [self saveHistory:dic key:CA_H_FoundBrowseHistoryAggregate];
}

- (void)saveHistory:(id)text key:(NSString *)key {
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:[CA_H_UserDefaults objectForKey:key]];
    
    NSUInteger index = [mutArray indexOfObject:text];
    if (index != NSNotFound) {
        [mutArray removeObjectAtIndex:index];
    }
    [mutArray insertObject:text atIndex:0];
    while (mutArray.count > 10) {
        [mutArray removeLastObject];
    }
    [CA_H_UserDefaults setObject:mutArray forKey:key];
}

- (void)cleanSearch {
    [CA_H_UserDefaults setObject:@[] forKey:CA_H_FoundSearchHistoryAggregate];
}
- (void)cleanBrowse {
    [CA_H_UserDefaults setObject:@[] forKey:CA_H_FoundBrowseHistoryAggregate];
}


#pragma mark --- Delegate

@end
