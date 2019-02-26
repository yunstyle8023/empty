//
//  CA_HMoveListModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMoveListModel.h"

@implementation CA_HNoteTypeModel

@end

@implementation CA_HMoveListModel

- (NSMutableArray<CA_MProjectModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

/**
 数据请求调用
 */
- (void (^)(NSString *, BOOL))loadMoreBlock {
    if (!_loadMoreBlock) {
        CA_H_WeakSelf(self);
        _loadMoreBlock = ^ (NSString *keyword, BOOL isMember) {
            CA_H_StrongSelf(self);
            
            NSDictionary *parameters;
            
            if (isMember) {
                parameters =
                @{
                  @"page_num":@(self.page_num.integerValue + 1),
                  @"keyword":keyword?:@"",
                  @"member_type":@"associated"
                  };
            } else {
                parameters =
                @{
                  @"page_num":@(self.page_num.integerValue + 1),
                  @"keyword":keyword?:@""
                  };
            }
            
            
            [self.dataTask cancel];
            self.dataTask =
            [CA_HNetManager postUrlStr:CA_M_Api_ListProject
                            parameters:parameters
                              callBack:^(CA_HNetModel *netModel) {
                                  
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
        if (netModel.errcode.integerValue == 0) {
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
        CA_MProjectModel *model = [CA_MProjectModel modelWithDictionary:dic];
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

@end
