//
//  UIView+XuSong.m
//  demo
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "UIView+XuSong.h"

@implementation UIView (XuSong)
-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}
@end
