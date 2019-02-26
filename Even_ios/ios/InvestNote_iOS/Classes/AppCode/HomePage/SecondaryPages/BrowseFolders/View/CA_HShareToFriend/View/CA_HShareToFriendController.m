//
//  CA_HShareToFriendController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HShareToFriendController.h"

@interface CA_HShareToFriendController ()

@property (nonatomic, strong) UIView *shareView;

@end

@implementation CA_HShareToFriendController

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    self.viewModel.shareBlock(sender.tag == 101);
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark --- Lazy

- (CA_HShareToFriendViewModel *)viewModel {
    if (!_viewModel) {
        CA_HShareToFriendViewModel *viewModel = [CA_HShareToFriendViewModel new];
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIView *)shareView {
    if (!_shareView) {
        _shareView = self.viewModel.shareViewBlock(self, @selector(onButton:));
    }
    return _shareView;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    NSLog(@"%@----->dealloc",[self class]);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upConfig {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)upView {
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    }];

    [self.view addSubview:self.shareView];
    self.shareView.sd_layout
    .heightIs(222*CA_H_RATIO_WIDTH)
    .widthIs(335*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view);
    self.shareView.sd_cornerRadius = @(10*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
