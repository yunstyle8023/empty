//
//  CA_MDiscoverSponsorItemDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemProjectModel.h"


@implementation CA_MDiscoverSponsorItemProjectData_list

@end

@implementation CA_MDiscoverSponsorItemProjectModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverSponsorItemProjectData_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorItemProjectData_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
