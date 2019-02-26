//
//  CA_HStatisticsViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HStatisticsViewManager.h"

@interface CA_HStatisticsViewManager ()

@end

@implementation CA_HStatisticsViewManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)contentViewWithItem:(NSInteger)item {
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = CA_H_FONT_PFSC_Semibold(300);
    label.textColor = [UIColor colorWithRGB:arc4random() alpha:1];
    label.text = @(item).stringValue;
    
    [view addSubview:label];
    label.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    
    return view;
}

#pragma mark --- Delegate

@end
