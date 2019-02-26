//
//  CA_HAddNoteViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteViewManager.h"

@interface CA_HAddNoteViewManager ()

@end

@implementation CA_HAddNoteViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *button = [UIButton new];
        _rightButton = button;
        
        button.frame = CGRectMake(0, 0, 70, 44);
        [button setTitle:CA_H_LAN(@"保存") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 70-titleSize.width, 0, 0)];
    }
    return _rightButton;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIBarButtonItem *)barButtonItem:(id)target action:(SEL)action {
    [self.rightButton setTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}

#pragma mark --- Delegate


@end
