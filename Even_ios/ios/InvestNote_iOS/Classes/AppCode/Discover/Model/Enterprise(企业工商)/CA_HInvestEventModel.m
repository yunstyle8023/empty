//
//  CA_HInvestEventModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HInvestEventModel.h"

@implementation CA_HInvestEventData

@end

@implementation CA_HInvestEventModel

- (void)setData_list:(NSArray<CA_HInvestEventData *> *)data_list {
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[CA_HInvestEventData class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HInvestEventData modelWithDictionary:dic]];
        }
    }
    _data_list = array;
}

@end
