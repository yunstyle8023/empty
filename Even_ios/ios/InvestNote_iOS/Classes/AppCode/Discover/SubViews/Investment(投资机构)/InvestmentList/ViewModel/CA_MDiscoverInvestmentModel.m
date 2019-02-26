//
//  CA_MDiscoverInvestmentModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentModel.h"

@implementation CA_MDiscoverInvestmentFilterData

@end

@implementation CA_MDiscoverInvestmentData_list

@end

@implementation CA_MDiscoverInvestmentModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverInvestmentData_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverInvestmentData_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
