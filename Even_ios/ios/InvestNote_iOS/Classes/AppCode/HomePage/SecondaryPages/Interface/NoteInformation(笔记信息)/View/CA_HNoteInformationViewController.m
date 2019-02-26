//
//  CA_HNoteInformationViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteInformationViewController.h"

#import "CA_HNoteInformationViewManager.h"

@interface CA_HNoteInformationViewController ()

@property (nonatomic, strong) CA_HNoteInformationViewManager *viewManager;


@end

@implementation CA_HNoteInformationViewController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HNoteInformationViewModel *)viewModel {
    if (!_viewModel) {
        CA_HNoteInformationViewModel *viewModel = [CA_HNoteInformationViewModel new];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (CA_HNoteInformationViewManager *)viewManager {
    if (!_viewManager) {
        CA_HNoteInformationViewManager *viewManager = [CA_HNoteInformationViewManager new];
        _viewManager = viewManager;
    }
    return _viewManager;
}


#pragma mark --- LifeCircle

- (instancetype)init
{
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.viewManager.informationView.right = self.view.right;
    }];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    CA_H_MANAGER.mainWindow.windowLevel = UIWindowLevelStatusBar;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    CA_H_MANAGER.mainWindow.windowLevel = UIWindowLevelNormal;
//}

#pragma mark --- Custom

- (void)upConfig {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)upView {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    [self.view addSubview:self.viewManager.informationView];
    self.viewManager.informationView.sd_layout
    .widthIs(240*CA_H_RATIO_WIDTH)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.viewManager.informationView.left = self.view.right;
    
    self.viewManager.TopStrings = self.viewModel.topArray;
    self.viewManager.BottomStrings = self.viewModel.bottomArray;
}

#pragma mark --- Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BOOL set = YES;
    for (UITouch * touch in touches) {
        if (touch.view == self.viewManager.informationView) {
            set = NO;
        }
    }
    if (set) {
        [UIView animateWithDuration:0.25 animations:^{
            self.viewManager.informationView.left = self.view.right;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}


@end
