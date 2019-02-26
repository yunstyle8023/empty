//
//  CA_HRemarkViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HRemarkViewModel.h"

@interface CA_HRemarkViewModel () <YYTextViewDelegate>

@end

@implementation CA_HRemarkViewModel

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    if (_backBlock) {
        NSString * text = nil;
        if (sender.tag == 101) {
            text = self.textView.text?:@"";
        }
        _backBlock(text);
    }
}

#pragma mark --- Lazy

- (UIBarButtonItem *)leftBarButtonItem{
    if (!_leftBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 100;
        
        [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70-titleSize.width)];
        
        button.frame = CGRectMake(0, 0, 70, 44);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }
    return _leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 101;
        
        [button setTitle:CA_H_LAN(@"保存") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 70-titleSize.width, 0, 0)];
        
        button.frame = CGRectMake(0, 0, 70, 44);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        button.enabled = NO;
    }
    return _rightBarButtonItem;
}

- (YYTextView *)textView{
    if (!_textView) {
        YYTextView * textView = [YYTextView new];
        
        textView.textContainerInset = UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
        
        textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
        textView.placeholderTextColor = CA_H_9GRAYCOLOR;
        
        textView.font = CA_H_FONT_PFSC_Regular(16);
        textView.textColor = CA_H_4BLACKCOLOR;
        
        textView.delegate = self;
        
        _textView = textView;
    }
    return _textView;
}

#pragma mark --- TextView

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [CA_HAppManager textView:textView shouldChangeTextInRange:range replacementText:text];
}

- (void)textViewDidChange:(YYTextView *)textView{
    UIButton * button = (id)self.rightBarButtonItem.customView;
    if (textView.text.length) {
        button.enabled = YES;
    }else{
        button.enabled = NO;
    }
}

@end
