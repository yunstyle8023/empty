//
//  CA_HFoundFactoryPattern.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HFoundFactoryPattern : NSObject

// 头部搜索
+ (UIView *)searchHeaderView:(id)target action:(SEL)action;

// 导航条阴影
+ (void)showShadowWithView:(UIView *)view;
+ (void)hideShadowWithView:(UIView *)view;

// Label
+ (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color;

// Line
+ (UIView *)line;
+ (UIView *)lineWithView:(UIView *)view left:(CGFloat)left right:(CGFloat)right;
+ (UIView *)lineSpace20:(UIView *)view;

// BarButtonItem
+ (UIBarButtonItem *)barButtonItem:(NSString *)imageName size:(CGSize)size target:(id)target action:(SEL)action;

// 生成长图
+ (void)generateImage:(UIImage *)image nav:(UINavigationController *)nvc;


@end
