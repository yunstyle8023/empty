//
//  CA_HFoundSearchModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundSearchModelManager.h"

@interface CA_HFoundSearchModelManager ()

@end

@implementation CA_HFoundSearchModelManager {
    NSURLSessionDataTask *_dataTask;
}

#pragma mark --- Action

#pragma mark --- Lazy

- (NSString *)searchHolder {
    switch (self.type) {
        case CA_HFoundSearchTypeProject: //项目
            self.dataType = @"project";
            self.recentSearchKey = CA_H_FoundSearchHistoryProject;
            self.recentBrowseKey = CA_H_FoundBrowseHistoryProject;
            self.cellClassStr = @"CA_HFoundProjectListCell";
            self.countText = @"条项目";
            self.rowHeight = 67*CA_H_RATIO_WIDTH;
            self.nullText = @"没有搜索到相关项目";
            return @"输入项目名称";
        case CA_HFoundSearchTypeEnterprise: //企业工商
            self.dataType = @"enterprise";
            self.recentSearchKey = CA_H_FoundSearchHistoryEnterprise;
            self.recentBrowseKey = CA_H_FoundBrowseHistoryEnterprise;
            self.cellClassStr = @"CA_HFoundEnterpriseSearchCell";
            self.countText = @"条企业";
            self.rowHeight = 67*CA_H_RATIO_WIDTH;
            self.nullText = @"没有搜索到相关企业";
            return @"输入企业名/品牌/人名";
        case CA_HFoundSearchTypeLp: //出资人
            self.dataType = @"lp";
            self.recentSearchKey = CA_H_FoundSearchHistoryLp;
            self.recentBrowseKey = CA_H_FoundBrowseHistoryLp;
            self.cellClassStr = @"CA_HFoundLpSearchCell";
            self.countText = @"条出资人";
            self.rowHeight = 90*CA_H_RATIO_WIDTH;
            self.nullText = @"没有搜索到相关出资人";
            return @"输入出资人名称";
        case CA_HFoundSearchTypeGp: //出资机构
            self.dataType = @"gp";
            self.recentSearchKey = CA_H_FoundSearchHistoryGp;
            self.recentBrowseKey = CA_H_FoundBrowseHistoryGp;
            self.cellClassStr = @"CA_HFoundGpSearchCell";
            self.countText = @"条机构信息";
            self.rowHeight = 116*CA_H_RATIO_WIDTH;
            self.nullText = @"没有搜索到相关机构信息";
            return @"输入机构名称";
        default:
            self.dataType = @"";
            self.recentSearchKey = @"";
            self.recentBrowseKey = @"";
            self.cellClassStr = @"";
            self.countText = @"";
            self.rowHeight = 0;
            self.nullText = @"";
            return @"";
    }
}

- (NSArray *)recentSearch {
    return [CA_H_UserDefaults objectForKey:self.recentSearchKey];
}

- (NSArray *)recentBrowse {
    return [CA_H_UserDefaults objectForKey:self.recentBrowseKey];
}

- (CA_HFoundSearchModel *)model {
    if (!_model) {
        CA_HFoundSearchModel *model = [CA_HFoundSearchModel new];
        _model = model;
    }
    return _model;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSString *)headerText {
    
    NSInteger count = self.model.total_count.integerValue;
    
    NSString *str = count>1000?@"1000+":[NSString stringWithFormat:@"%ld", count];
    
    return [NSString stringWithFormat:@"<font color='#999999'>搜索到</font><font color='#5E69C7'> %@ </font><font color='#999999'>%@</font>", str, self.countText];
}

- (void)setSearchText:(NSString *)searchText {
    if (searchText.length > 1) {
        if (![searchText isEqualToString:_searchText]) {
            _searchText = searchText;
            [self.model setPage_num:@(0)];
            [self loadMore];
        }
    } else {
        _searchText = nil;
        [_dataTask cancel];
        [self.data removeAllObjects];
        if (self.finishBlock) self.finishBlock(NO);
    }
}



#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)saveSearch:(NSString *)text {
    [self saveHistory:text key:self.recentSearchKey];
}

- (void)saveBrowse:(NSDictionary *)dic {
    [self saveHistory:dic key:self.recentBrowseKey];
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
    [CA_H_UserDefaults setObject:@[] forKey:self.recentSearchKey];
}
- (void)cleanBrowse {
    [CA_H_UserDefaults setObject:@[] forKey:self.recentBrowseKey];
}


- (void)loadMore {
    
    NSDictionary *parameters = nil;
    if (self.type == CA_HFoundSearchTypeGp) {
        parameters =
        @{@"data_type": self.dataType?:@"",
          @"search_str": [NSString stringWithFormat:@"all+all+%@", self.searchText?:@""],
          @"search_type": @"area+captial_type+str",
          @"page_size": @(20),
          @"page_num": @([self.model page_num].integerValue+1)};
    } else {
        parameters =
        @{@"data_type": self.dataType?:@"",
          @"search_str": self.searchText?:@"",
          @"search_type": @"keyword",
          @"page_size": @(20),
          @"page_num": @([self.model page_num].integerValue+1)};
    }
    
    
    [_dataTask cancel];
    
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager postUrlStr:CA_M_SearchDataList parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                
                [self.model modelSetWithDictionary:netModel.data];
                CA_HFoundSearchModel *model = self.model;
                
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


#pragma mark --- Delegate

@end
