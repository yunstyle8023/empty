//
//  CA_HMineViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineViewModel.h"

@interface CA_HMineViewModel ()

@end

@implementation CA_HMineViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (NSArray *)data {
    return @[@"",
//             CA_H_LAN(@"个人统计"),
             CA_H_LAN(@"我的审批"),
             CA_H_LAN(@"下载中心"),
             CA_H_LAN(@"消息通知"),
             CA_H_LAN(@"设置")];
}

- (NSArray *)imgs {
    return @[@"",
//           @"",
             @"icons_approval",
             @"icons_down",
             @"icons_mass",
             @"icons_setting2"];
}

- (CA_HMineModel *)model {
    if (!_model) {
        CA_HMineModel *model = [CA_HMineModel new];
        _model = model;
    }
    return _model;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
