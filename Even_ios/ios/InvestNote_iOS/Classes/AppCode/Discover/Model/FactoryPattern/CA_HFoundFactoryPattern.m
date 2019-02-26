//
//  CA_HFoundFactoryPattern.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundFactoryPattern.h"

#import "CA_HLongViewController.h" // 生成长图

@implementation CA_HFoundFactoryPattern

// 头部搜索
+ (UIView *)searchHeaderView:(id)target action:(SEL)action {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 50*CA_H_RATIO_WIDTH);
    
    CA_HSetButton *searchButton = [CA_HSetButton new];
    
    searchButton.backgroundColor = CA_H_F8COLOR;
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
    searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
    [searchButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:searchButton];
    searchButton.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
    
    return view;
}

// 导航条阴影
+ (void)showShadowWithView:(UIView *)view {
    [CA_HShadow dropShadowWithView:view
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

+ (void)hideShadowWithView:(UIView *)view {
    [CA_HShadow dropShadowWithView:view
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

// Label
+ (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 1;
    return label;
}

// Line
+ (UIView *)line {
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    return line;
}
+ (UIView *)lineWithView:(UIView *)view left:(CGFloat)left right:(CGFloat)right {
    UIView *line = self.line;
    [view addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(view)
    .rightSpaceToView(view, right)
    .leftSpaceToView(view, left);
    return line;
}
+ (UIView *)lineSpace20:(UIView *)view {
    CGFloat space = 20*CA_H_RATIO_WIDTH;
    return [self lineWithView:view left:space right:space];
}

// BarButtonItem
+ (UIBarButtonItem *)barButtonItem:(NSString *)imageName size:(CGSize)size target:(id)target action:(SEL)action {
    UIButton *button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.size = size;
    [button addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

// 生成长图
+ (void)generateImage:(UIImage *)image nav:(UINavigationController *)nvc {
    CA_HLongViewController* longViewVC = [CA_HLongViewController new];
    longViewVC.type = CA_HLongTypeFound;
    longViewVC.image = image;
    [nvc pushViewController:longViewVC animated:YES];
}

@end
