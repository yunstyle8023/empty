//
//  UIButton+CA_M_Button.h
//  ceshi
//
//  Created by yezhuge on 2017/11/18.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CA_MButton)

/**
 设置button的title titleColor fontSize

 @param title 标题
 @param titleColor 标题颜色
 @param fontSize 标题字体大小
 */
- (void)configTitle:(NSString*)title
         titleColor:(UIColor*)titleColor
               font:(CGFloat)fontSize;

@end
