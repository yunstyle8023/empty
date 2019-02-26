
//
//  CA_MDiscoverSponsorListModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorListModel.h"
#import "CA_MDiscoverSponsorModel.h"

@implementation CA_MDiscoverSponsorListModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverSponsorData_list *> *)data_list{
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
