//
//  CA_HShadow.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HShadow.h"

@implementation CA_HShadow

/**
 添加阴影
 
 @param view 添加阴影视图控件
 @param offset 阴影偏移量 默认（0，-3）
 @param radius 阴影圆角 默认 3
 @param color 阴影颜色
 @param opacity 阴影不透明度 [0,1] 默认 0
 */
+ (void)dropShadowWithView:(UIView *)view
                    bounds:(CGRect)bounds
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    view.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = offset;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    view.clipsToBounds = NO;
}

+ (void)dropShadowWithView:(UIView *)view
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity{
    [self dropShadowWithView:view bounds:view.bounds offset:offset radius:radius color:color opacity:opacity];
}

+ (void)dropShadowWithView:(UIView *)view
                    bounds:(CGRect)bounds
              cornerRadius:(CGFloat)cornerRadius
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity {
    
    CALayer *sublayer =[CALayer layer];
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    sublayer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    sublayer.shadowOffset = offset;
    sublayer.shadowRadius = radius;
    sublayer.shadowColor = color.CGColor;
    sublayer.shadowOpacity = opacity;
    sublayer.cornerRadius = cornerRadius;
    sublayer.masksToBounds = NO;
    
    [view.layer addSublayer:sublayer];
}

+ (void)showUpdate:(BOOL)isWhite text:(NSString *)text size:(CGSize)size{
    
    CGFloat y = size.height - 48*CA_H_RATIO_WIDTH;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake((CA_H_SCREEN_WIDTH-size.width-24*CA_H_RATIO_WIDTH)/2, y, size.width+24*CA_H_RATIO_WIDTH, 60*CA_H_RATIO_WIDTH);
    view.alpha = 0;
    
    UILabel *label = [UILabel new];
    label.font = CA_H_FONT_PFSC_Medium(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.frame = CGRectMake(12*CA_H_RATIO_WIDTH, 12*CA_H_RATIO_WIDTH, size.width, 36*CA_H_RATIO_WIDTH);
    label.layer.cornerRadius = 18*CA_H_RATIO_WIDTH;
    label.layer.masksToBounds = YES;
    [view addSubview:label];
    
    if (isWhite) {
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = CA_H_TINTCOLOR;
    } else {
        label.backgroundColor = CA_H_TINTCOLOR;
        label.textColor = [UIColor whiteColor];
    }
    
    UIColor *shadowColor = isWhite?CA_H_SHADOWCOLOR:CA_H_TINTCOLOR;
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = label.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius = 18*CA_H_RATIO_WIDTH;
    subLayer.backgroundColor=[UIColor whiteColor].CGColor;//[shadowColor colorWithAlphaComponent:1].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 1;//阴影透明度，默认0
    subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
    
    [view.layer insertSublayer:subLayer below:label.layer];
    
    [CA_H_MANAGER.mainWindow addSubview:view];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
        view.mj_y = y+36*CA_H_RATIO_WIDTH;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
            view.alpha = 0;
            view.mj_y = y;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];

}

@end
