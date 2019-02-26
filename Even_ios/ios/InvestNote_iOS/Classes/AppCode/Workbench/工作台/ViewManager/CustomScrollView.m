//
//  CustomScrollView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView
//解决手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return gestureRecognizer.state != 0 ? YES : NO;
}
@end
