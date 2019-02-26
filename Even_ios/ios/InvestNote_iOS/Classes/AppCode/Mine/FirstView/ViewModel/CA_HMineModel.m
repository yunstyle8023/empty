//
//  CA_HMineModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineModel.h"

@implementation CA_HMineUserInfoModel

@end

@implementation CA_HMineCountModel

@end

@implementation CA_HMineModel

- (void)setUser_info:(CA_HMineUserInfoModel *)user_info {
    if ([user_info isKindOfClass:[NSDictionary class]]) {
        _user_info = [CA_HMineUserInfoModel modelWithDictionary:(id)user_info];
    } else {
        _user_info = user_info;
    }
}

- (void)setPersonal_count:(NSArray<CA_HMineCountModel *> *)personal_count {
    if (![personal_count isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in personal_count) {
        if ([dic isKindOfClass:[CA_HMineCountModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HMineCountModel modelWithDictionary:dic]];
        }
    }
    _personal_count = array;
}

- (void)loadData {
    [self.dataTask cancel];
    CA_H_WeakSelf(self);
    self.dataTask =
    [CA_HNetManager postUrlStr:CA_H_Api_CountUserStatistics
                    parameters:@{}
                      callBack:^(CA_HNetModel *netModel) {
                          CA_H_StrongSelf(self);
                          self.PostFinish = netModel;
                      } progress:nil];
}

- (void)setPostFinish:(CA_HNetModel *)netModel {
    if (netModel.type == CA_H_NetTypeSuccess) {
        if (netModel.errcode.integerValue == 0
            &&
            [netModel.data isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:netModel.data];
            [self reloadType:YES];
            return;
        }
    }
    [self reloadType:NO];
}

- (void)reloadType:(BOOL)success {
    if (self.finishRequestBlock) {
        self.finishRequestBlock(success);
    }
}

@end
