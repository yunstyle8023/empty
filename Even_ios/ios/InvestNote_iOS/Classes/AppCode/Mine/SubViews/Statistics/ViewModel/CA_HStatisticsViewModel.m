//
//  CA_HStatisticsViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HStatisticsViewModel.h"

@interface CA_HStatisticsViewModel ()

@end

@implementation CA_HStatisticsViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (NSString *)title {
    return CA_H_LAN(@"个人统计");
}

- (NSArray *)data {
    return @[CA_H_LAN(@"项目"),
             CA_H_LAN(@"人脉"),
             CA_H_LAN(@"笔记"),
             CA_H_LAN(@"待办"),
             CA_H_LAN(@"LP"),
             CA_H_LAN(@"文件")];
}


#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
