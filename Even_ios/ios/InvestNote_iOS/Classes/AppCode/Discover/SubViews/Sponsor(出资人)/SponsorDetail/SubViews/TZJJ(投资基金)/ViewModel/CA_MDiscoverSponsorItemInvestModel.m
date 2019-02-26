//
//  CA_MDiscoverSponsorItemInvestModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemInvestModel.h"

@implementation CA_MDiscoverSponsorItemInvestRequestModel 

@end

@implementation CA_MDiscoverSponsorItemInvestData_list

@end

@implementation CA_MDiscoverSponsorItemInvestModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverSponsorItemInvestData_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorItemInvestData_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
