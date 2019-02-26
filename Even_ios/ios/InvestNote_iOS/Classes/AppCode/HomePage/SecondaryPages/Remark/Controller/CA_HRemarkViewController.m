//
//  CA_HRemarkViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HRemarkViewController.h"

#import "CA_HRemarkViewModel.h"

@interface CA_HRemarkViewController () <YYTextKeyboardObserver>

@property (nonatomic, strong) CA_HRemarkViewModel * viewModel;

@end

@implementation CA_HRemarkViewController

#pragma mark --- Lazy

- (CA_HRemarkViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_HRemarkViewModel new];
        
        CA_H_WeakSelf(self);
        _viewModel.backBlock = ^(NSString *text) {
            CA_H_StrongSelf(self);
            if (text) {
                
                if (text.length > 500) {
                    [self presentAlertTitle:nil message:CA_H_LAN(@"当前可输入字数\n不能超过500字") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
                    return;
                }
                
                if (self.backBlock) {
                    self.backBlock(text);
                }
            }
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
    }
    return _viewModel;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.viewModel.textView.text = text;
}

- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    self.viewModel.textView.placeholderText = placeholderText;
}

#pragma mark --- LifeCircle

- (void)dealloc{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}



#pragma mark --- Custom

- (void)upView{
    
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItem;
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.viewModel.leftBarButtonItem;
    
    [self.view addSubview:self.viewModel.textView];
    self.viewModel.textView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
}

#pragma mark --- Keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    self.viewModel.textView.sd_closeAutoLayout = YES;
    if (transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            self.viewModel.textView.frame = textFrame;
            clipped = YES;
        }
    }

    if (!clipped) {
        self.viewModel.textView.frame = self.view.bounds;
    }
}

@end
