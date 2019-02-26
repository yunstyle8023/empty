//
//  CA_MProjectTraceMutilTModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceMutilTModel.h"
#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MProjectTraceMutiltRequestModel

@end

@implementation CA_MProjectTraceMutilTModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverCompatible_project_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        [array addObject:[CA_MDiscoverCompatible_project_list modelWithDictionary:dic]];
    }
    _data_list = array;
}

@end
