//
//  ButtonLabel.h
//  DaDaBus
//
//  Created by Sylvia on 14-8-15.
//  Copyright (c) 2014年 Bus. All rights reserved.
//
/*
    自定义的有点击效果的Label
 */
#import <UIKit/UIKit.h>

@interface ButtonLabel : UILabel
//{
//
//}
///*
//    正常状态背景颜色 默认系统颜色
// */
//
//@property (nonatomic, strong) UIColor *backGroudNormalColor;
///*
//    点击状态背景颜色 默认系统颜色
// */
//@property (nonatomic, strong) UIColor *backGroudTouchColor;
///*
//    正常状态文字颜色 默认系统颜色
// */
//@property (nonatomic, strong) UIColor *textNormalColor;
///*
//    点击状态文字颜色 默认系统颜色
// */
//@property (nonatomic, strong) UIColor *textTouchColor;
//@property(nonatomic,assign)BOOL selected;
/*
    点击事件
 */
@property (nonatomic,copy) void(^didSelect)(ButtonLabel* sender);
@end
