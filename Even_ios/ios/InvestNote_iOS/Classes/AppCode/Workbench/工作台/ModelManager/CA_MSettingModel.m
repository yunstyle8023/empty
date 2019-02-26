
//
//  CA_MSettingModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingModel.h"


@implementation CA_MSettingListModel

@end

@implementation CA_MSettingAvaterModel

@end

@implementation CA_MSettingModel

-(void)setMod_list:(NSArray<CA_MSettingListModel *> *)mod_list{
    if (![mod_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in mod_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MSettingListModel modelWithDictionary:dic]];
        }
    }
    _mod_list = temp;
}

@end
