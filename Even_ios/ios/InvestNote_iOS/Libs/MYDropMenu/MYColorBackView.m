//
//  MYColorBackView.m
//  MYPresentedController_Example
//
//  Created by 孟遥 on 2017/2/23.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "MYColorBackView.h"

@implementation MYColorBackView

- (UIView *)topView
{
    if (!_topView) {
        CGFloat height = kDevice_Is_iPhoneX?88:64;
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,height)];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIView *)backColorView
{
    if (!_backColorView) {
        CGFloat height = kDevice_Is_iPhoneX?88:64;
        _backColorView = [[UIView alloc]initWithFrame:CGRectMake(0,height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - height)];
    }
    return _backColorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topView];
        [self addSubview:self.backColorView];
    }
    return self;
}

@end

