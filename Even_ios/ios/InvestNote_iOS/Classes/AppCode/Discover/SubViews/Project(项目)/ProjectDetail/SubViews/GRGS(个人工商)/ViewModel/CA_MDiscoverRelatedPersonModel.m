
//
//  CA_MDiscoverRelatedPersonModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonModel.h"

@implementation CA_MDiscoverRelatedPersonRequestModel

@end

@implementation CA_MDiscoverRelatedPersonData_list

@end

@implementation CA_MDiscoverRelatedPersonModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverRelatedPersonData_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverRelatedPersonData_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
