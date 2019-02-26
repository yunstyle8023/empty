//
//  CA_MDiscoverModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverModel.h"

@implementation CA_MDiscoverSponsorRequestModel

@end

@implementation CA_MDiscoverRequestModel

@end

@implementation CA_MModuleModel

@end

@implementation CA_MCommonModel

@end

@implementation CA_MDiscoverModel

-(void)setData_list:(NSMutableArray<CA_MCommonModel *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MCommonModel modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

-(void)setModules_list:(NSMutableArray<CA_MModuleModel *> *)modules_list{
    if (![modules_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in modules_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MModuleModel modelWithDictionary:dic]];
        }
    }
    _modules_list = temp;
}

@end
