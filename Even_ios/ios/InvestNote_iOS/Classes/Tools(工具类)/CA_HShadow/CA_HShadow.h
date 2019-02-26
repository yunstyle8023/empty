//
//  CA_HShadow.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HShadow : NSObject


/**
    添加阴影

 @param view 添加阴影视图控件
 @param offset 阴影偏移量 默认（0，-3）
 @param radius 阴影圆角 默认 3
 @param color 阴影颜色
 @param opacity 阴影不透明度 [0,1] 默认 0
 */
+ (void)dropShadowWithView:(UIView *)view
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity;

+ (void)dropShadowWithView:(UIView *)view
                    bounds:(CGRect)bounds
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity;

+ (void)dropShadowWithView:(UIView *)view
                    bounds:(CGRect)bounds
              cornerRadius:(CGFloat)cornerRadius
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity;

+ (void)showUpdate:(BOOL)isWhite
              text:(NSString *)text
              size:(CGSize)size;

@end
