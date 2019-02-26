//
//  CA_HEnterpriseBusinessInfoModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HEnterpriseBusinessInfoModel.h"


@implementation CA_HEnterpriseModules

@end

@implementation CA_HEnterpriseCreditreport

@end

@implementation CA_HEnterpriseStock

@end

@implementation CA_HEnterpriseBusinessInfoModel

- (void)setRisk_modules_list:(NSArray<CA_HEnterpriseModules *> *)risk_modules_list {
    if (![risk_modules_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in risk_modules_list) {
        if ([dic isKindOfClass:[CA_HEnterpriseModules class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HEnterpriseModules modelWithDictionary:dic]];
        }
    }
    _risk_modules_list = array;
}

- (void)setBasic_modules_list:(NSArray<CA_HEnterpriseModules *> *)basic_modules_list {
    if (![basic_modules_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in basic_modules_list) {
        if ([dic isKindOfClass:[CA_HEnterpriseModules class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HEnterpriseModules modelWithDictionary:dic]];
        }
    }
    _basic_modules_list = array;
}

- (void)setStock_modules_list:(NSArray<CA_HEnterpriseModules *> *)stock_modules_list {
    if (![stock_modules_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in stock_modules_list) {
        if ([dic isKindOfClass:[CA_HEnterpriseModules class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HEnterpriseModules modelWithDictionary:dic]];
        }
    }
    _stock_modules_list = array;
}


@end
