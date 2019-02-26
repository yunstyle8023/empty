//
//  CA_HHomeSearchViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchViewController.h"

#import "CA_HHomeSearchViewModel.h"

@interface CA_HHomeSearchViewController () <YYTextKeyboardObserver>

@property (nonatomic, strong) CA_HHomeSearchViewModel * viewModel;

@end

@implementation CA_HHomeSearchViewController

#pragma mark --- Lazy

- (CA_HHomeSearchViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_HHomeSearchViewModel new];
        
        CA_H_WeakSelf(self);
        _viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
        _viewModel.backBlock = ^{
            CA_H_StrongSelf(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        _viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _viewModel;
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    if (buttonTitle.length) {
        self.viewModel.ButtonTitle = CA_H_LAN(buttonTitle);
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.titleView resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel.titleView becomeFirstResponder];
}

- (void)upView{
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItem;
    self.navigationItem.titleView = self.viewModel.titleView;
    
    [self.view addSubview:self.viewModel.tableView];
    self.viewModel.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
}



#pragma mark --- Keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    self.viewModel.tableView.sd_closeAutoLayout = YES;
    if (transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            self.viewModel.tableView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        self.viewModel.tableView.frame = self.view.bounds;
    }
}


@end
