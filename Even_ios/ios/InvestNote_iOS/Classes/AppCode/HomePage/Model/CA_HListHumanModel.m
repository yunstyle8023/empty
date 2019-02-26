//
//  CA_HListHumanModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HListHumanModel.h"



@implementation CA_HListHumanModel

- (NSMutableArray<CA_MPersonModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

/**
 数据请求调用
 */
- (void (^)(NSString *))loadMoreBlock {
    if (!_loadMoreBlock) {
        CA_H_WeakSelf(self);
        _loadMoreBlock = ^ (NSString *keyword) {
            CA_H_StrongSelf(self);
            
            NSDictionary *parameters = @{@"tag_id_list":@[],
                                         @"keyword":keyword?:@""};
            [self.dataTask cancel];
            self.dataTask =
            [CA_HNetManager postUrlStr:CA_M_Api_ListHumanrResource
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
        if (netModel.errcode.integerValue == 0
            &&
            [netModel.data isKindOfClass:[NSArray class]]) {
            
            [self.data removeAllObjects];
            for (NSDictionary* dic in netModel.data) {
                CA_MPersonModel* model = [CA_MPersonModel modelWithDictionary:dic];
                model.select = YES;
                [self.data addObject:model];
            }
            
            [self reloadType:CA_H_RefreshTypeNomore];
        }else{
            [self reloadType:CA_H_RefreshTypeFail];
        }
    }else {
        [self reloadType:CA_H_RefreshTypeFail];
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

- (void)dealloc {
    [_dataTask cancel];
    _dataTask = nil;
}


@end
