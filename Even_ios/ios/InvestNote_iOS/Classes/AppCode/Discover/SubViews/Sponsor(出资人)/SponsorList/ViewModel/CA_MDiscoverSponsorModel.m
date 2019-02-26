
//
//  CA_MDiscoverSponsorModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorModel.h"

@implementation CA_MDiscoverSponsorData_list

@end

@implementation CA_MDiscoverSponsorModel

-(void)setData_list:(NSArray<CA_MDiscoverSponsorData_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorData_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
