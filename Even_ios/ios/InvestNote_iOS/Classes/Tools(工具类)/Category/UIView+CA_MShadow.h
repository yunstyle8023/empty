//
//  UIView+CA_MShadow.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2017/12/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CA_MShadow)
/*
 周边加阴影，并且同时圆角
 */
- (void)addShadowColor:(UIColor *)color
           withOpacity:(float)shadowOpacity
          shadowRadius:(CGFloat)shadowRadius
       andCornerRadius:(CGFloat)cornerRadius;
@end
