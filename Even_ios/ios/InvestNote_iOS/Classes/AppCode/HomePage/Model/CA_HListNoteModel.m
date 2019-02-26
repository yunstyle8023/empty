//
//  CA_HListNoteModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HListNoteModel.h"

@implementation CA_HListNoteContentModel

/**
 对更新时间进行处理

 @param ts_update 更新时间零时区字符串
 */
- (void)setTs_update:(NSNumber *)ts_update {
    _ts_update = ts_update;
    
    if (ts_update) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts_update.longValue];
        
        _date = date;
        _year = date.year;
        _month = date.month;
        _day = date.day;
        _time = [date stringWithFormat:@"HH:mm"];
    }
}

@end

@implementation CA_HListNoteModel

/**
 存放列表数据

 @return 给定内容的可变数组
 */
- (NSMutableArray<NSMutableArray<CA_HListNoteContentModel *> *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
//        if (CA_H_MANAGER.getToken.length) {
//            self.loadMoreBlock(@"");
//        }
    }
    return _data;
}

- (NSMutableArray<CA_HListNoteContentModel *> *)allData {
    if (!_allData) {
        _allData = [NSMutableArray new];
    }
    return _allData;
}


/**
 数据请求调用
 */
- (CA_HListNoteModel *(^)(NSString *))loadMoreBlock {
    if (!_loadMoreBlock) {
        CA_H_WeakSelf(self);
        _loadMoreBlock = ^CA_HListNoteModel *(NSString *keyword) {
            CA_H_StrongSelf(self);
            
            if (!keyword) keyword = @"";
            self.keyword = keyword;
            if (!self.objectId) self.objectId = @(0);
            if (!self.objectType) self.objectType = @"person";
            
            NSDictionary *parameters = @{@"keyword":keyword,
                                         @"object_type":self.objectType,
                                         @"object_id":self.objectId,
                                         @"page_num":@(self.page_num.integerValue + 1)};
            [self.dataTask cancel];
            
            if (!CA_H_MANAGER.getToken.length) {
                return self;
            }
            
            CA_H_WeakSelf(self);
            self.dataTask =
            [CA_HNetManager postUrlStr:CA_H_Api_ListNote
                            parameters:parameters
                              callBack:^(CA_HNetModel *netModel) {
                                  CA_H_StrongSelf(self);
                                  self.PostFinish = netModel;
                              } progress:nil];
            
            return self;
        };
    }
    return _loadMoreBlock;
}



/**
 网络请求数据处理

 @param netModel 网络请求模型
 */
- (void)setPostFinish:(CA_HNetModel *)netModel {
    if (netModel.type == CA_H_NetTypeSuccess) {
        if (netModel.errcode.integerValue == 0
            &&
            [netModel.data isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:netModel.data];
            CA_H_RefreshType type = CA_H_RefreshTypeDefine;
            if (self.page_num.integerValue == 1) {
                CA_HListNoteContentModel *dateModel = self.data.firstObject.firstObject;
                self.lastUpdate = dateModel.date;
                [self.data removeAllObjects];
                [self.allData removeAllObjects];
                type = CA_H_RefreshTypeFirst;
            }
            if (self.data_list.count>0) {
                [self reloadDate];
                
                if (self.page_num.integerValue >= self.page_count.integerValue) {
                    type = CA_H_RefreshTypeNomore;
                }
            }else {
                type = CA_H_RefreshTypeNomore;
            }
            
            [self reloadType:type];
        }else{
            [self reloadType:CA_H_RefreshTypeFail];
        }
    }else {
        [self reloadType:CA_H_RefreshTypeFail];
    }
}


/**
 数据处理
 */
- (void)reloadDate {
    
    for (NSDictionary * dic in self.data_list) {
        CA_HListNoteContentModel *model = [CA_HListNoteContentModel modelWithDictionary:dic];
        
        if (!self.data.lastObject
            ||
            self.data.lastObject.lastObject.year != model.year) {
            [self.data addObject:[NSMutableArray new]];
        }
        
        [self.data.lastObject addObject:model];
        [self.allData addObject:model];
    }
}



/**
 请求回调

 @param type 回调类型
 */
- (void)reloadType:(CA_H_RefreshType)type {
    if (self.finishRequestBlock) {
        self.finishRequestBlock(type);
    }
    
    if (type == CA_H_RefreshTypeFail
        ||
        !self.lastUpdate
        ||
        self.page_num.integerValue != 1) return;
    
    CA_HListNoteContentModel *dateModel = self.data.firstObject.firstObject;
    [self showUpdate:[dateModel.date compare:self.lastUpdate] == NSOrderedDescending];
}

- (void)showUpdate:(BOOL)success {
    if (self.noShow) {
        return;
    }
    NSString *text = success?CA_H_LAN(@"笔记同步成功"):CA_H_LAN(@"暂无数据更新");
    CGSize size = CGSizeMake(124*CA_H_RATIO_WIDTH, CA_H_MANAGER.xheight+64+48*CA_H_RATIO_WIDTH);
    [CA_HShadow showUpdate:!success text:text size:size];
}


#pragma mark --- 刷新

- (void)dealloc {
    [CA_H_NotificationCenter removeObserver:self];
    [_dataTask cancel];
    _dataTask = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [CA_H_NotificationCenter addObserver:self selector:@selector(reloadList:)  name:CA_H_RefreshNoteListNotification object:nil];
    }
    return self;
}

- (void)reloadList:(NSNotification*)notification {
    
    BOOL set1 = [notification.object isEqualToString:@"human"];
    BOOL set2 = [self.objectType isEqualToString:@"human"];
    
    if (set1 == set2) {
        NSNumber *pageSize = self.page_size?:@(30);
        NSNumber *pageNum = self.page_num?:@(1);
        
        if (!self.keyword) self.keyword = @"";
        if (!self.objectId) self.objectId = @(0);
        if (!self.objectType) self.objectType = @"person";
        
        
        NSDictionary *parameters =
        @{@"keyword":self.keyword,
          @"object_type":self.objectType,
          @"object_id":self.objectId,
          @"page_num":@(1),
          @"page_size":@(pageSize.integerValue*pageNum.integerValue)
          };
        
        BOOL noShow = self.noShow;
        self.noShow = YES;
        
        [self.dataTask cancel];
        CA_H_WeakSelf(self);
        self.dataTask =
        [CA_HNetManager postUrlStr:CA_H_Api_ListNote parameters:parameters callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            self.PostFinish = netModel;
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                self.page_size = pageSize;
                self.page_num = pageNum;
            }
            self.noShow = noShow;
        } progress:nil];
    }
    
}

@end
