//
//  CA_HBaseScrollVoew.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseScrollView.h"

@implementation CA_HBaseScrollView {
    BOOL __touchView;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (__touchView) {
            __touchView = NO;
            CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
            return translation.x > 0;
            return fabs(translation.x) > fabs(translation.y);
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == 3333/*[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]*/) {
        __touchView = YES;
    }
    return  YES;
}

@end
