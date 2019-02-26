//
//  CA_HListTodoModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HListTodoModel.h"

@implementation CA_HListTodoContentModel

- (void)setMember_list:(NSArray<CA_HParticipantsModel *> *)member_list {
    if (![member_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in member_list) {
        if ([dic isKindOfClass:[CA_HParticipantsModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HParticipantsModel modelWithDictionary:dic]];
        }
    }
    _member_list = array;
}

@end

@implementation CA_HListTodoModel

- (NSMutableArray<CA_HListTodoContentModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
        if (CA_H_MANAGER.getToken.length) {
            if (self.showFirstBlock) {
                self.showFirstBlock();
            }
            self.loadMoreBlock();
        }
    }
    return _data;
}

/**
 数据请求调用
 */
- (void (^)(void))loadMoreBlock {
    if (!_loadMoreBlock) {
        CA_H_WeakSelf(self);
        _loadMoreBlock = ^ {
            CA_H_StrongSelf(self);
            
            if (!self.objectType) self.objectType = @"person";
            if (!self.objectId) self.objectId = (id)@"pass";
            if (!self.status) self.status = @"ready";
            
            NSDictionary *parameters = @{@"object_type":self.objectType,
                                         @"object_id":self.objectId,
                                         @"status":self.status,
                                         @"page_num":@(self.page_num.integerValue + 1)};
            [self.dataTask cancel];
            
            if (!CA_H_MANAGER.getToken.length) {
                return;
            }
            
            CA_H_WeakSelf(self);
            self.dataTask =
            [CA_HNetManager postUrlStr:CA_H_Api_ListTodo
                            parameters:parameters
                              callBack:^(CA_HNetModel *netModel) {
                                  CA_H_StrongSelf(self);
                                  self.PostFinish = netModel;
                                  
                              } progress:nil];
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
                [self.data removeAllObjects];
                type = CA_H_RefreshTypeFirst;
            }
            if (self.data_list.count>0) {
                [self reloadDate];
                
                if (self.page_num.integerValue*self.page_size.integerValue >= self.total_count.integerValue) {
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
        CA_HListTodoContentModel *model = [CA_HListTodoContentModel modelWithDictionary:dic];
//        model.objectId = self.objectId.integerValue;
        [self.data addObject:model];
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
        [CA_H_NotificationCenter addObserver:self selector:@selector(reloadList:)  name:CA_H_RefreshTodoListNotification object:nil];
    }
    return self;
}

- (void)reloadList:(NSNotification*)notification{
    if ([self.status isEqualToString:notification.object]) {
        
        NSNumber *pageSize = self.page_size?:@(50);
        NSNumber *pageNum = self.page_num?:@(1);
        
        NSDictionary *parameters =
        @{@"object_type":self.objectType,
          @"object_id":self.objectId,
          @"status":self.status,
          @"page_num":@(1),
          @"page_size":@(pageSize.integerValue*pageNum.integerValue)
          };
        
        [self.dataTask cancel];
        CA_H_WeakSelf(self);
        self.dataTask =
        [CA_HNetManager postUrlStr:CA_H_Api_ListTodo parameters:parameters callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            
            self.PostFinish = netModel;
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                self.page_size = pageSize;
                self.page_num = pageNum;
            }
            
        } progress:nil];
    }
}



@end
