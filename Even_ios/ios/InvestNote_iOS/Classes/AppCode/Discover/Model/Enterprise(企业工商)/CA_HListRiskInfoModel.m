//
//  CA_HListRiskInfoModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HListRiskInfoModel.h"

@implementation CA_HListRiskInfoData

@end

@implementation CA_HListRiskInfoModel

- (void)setData_list:(NSArray<CA_HListRiskInfoData *> *)data_list {
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[CA_HListRiskInfoData class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HListRiskInfoData modelWithDictionary:dic]];
        }
    }
    _data_list = array;
}

@end
