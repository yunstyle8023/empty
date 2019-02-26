//
//  UIButton+CA_M_Button.m
//  ceshi
//
//  Created by yezhuge on 2017/11/18.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "UIButton+CA_MButton.h"

@implementation UIButton (CA_MButton)

- (void)configTitle:(NSString *)title
         titleColor:(UIColor *)titleColor
               font:(CGFloat)fontSize{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    self.titleLabel.font = CA_H_FONT_PFSC_Regular(fontSize);
}

@end
