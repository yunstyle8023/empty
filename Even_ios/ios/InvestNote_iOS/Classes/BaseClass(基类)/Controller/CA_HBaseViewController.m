//
//  CA_HBaseViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_HBaseViewController ()

@end

@implementation CA_HBaseViewController

#pragma mark --- Lazy

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        [self.view sd_addSubviews:@[_contentView]];
        if (@available(iOS 11.0, *)) {
            _contentView.sd_layout.spaceToSuperView(self.view.safeAreaInsets);
        }else {
            _contentView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        }
        [_contentView updateLayout];
    }
    return _contentView;
}

#pragma mark --- LifeCircle

- (void)dealloc{
    NSLog(@"%@----->dealloc",[self class]);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self upControllerConfig];
    if (self.navigationController) {
        [self upNavigation];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (_navBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated{
    if (_navBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [super viewWillDisappear:animated];
//    //辞去键盘第一响应者
//    [self resignFirstResponder];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self ca_layoutContentView];
}

- (void)ca_layoutContentView{
    if (_contentView) {
        if (@available(iOS 11.0, *)) {
            _contentView.sd_resetLayout.spaceToSuperView(self.view.safeAreaInsets);
        }else {
            _contentView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsZero);
        }
        [_contentView updateLayout];
    }
}

#pragma mark --- Custom


/**
    更新配置
 */
- (void)upControllerConfig{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}


/**
    更新Nav
 */
- (void)upNavigation{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self upNavigationBackButtonItem];
    }
}


/**
    更新nav返回按钮
 */
- (void)upNavigationBackButtonItem{

    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];

    backButton.frame = CGRectMake(15, 5, 38, 38);

    [backButton setImage:[UIImage imageNamed:@"icons_back"] forState:UIControlStateNormal];
    
    backButton.imageView.sd_resetLayout
    .widthIs(18)
    .heightEqualToWidth()
    .centerYEqualToView(backButton)
    .leftSpaceToView(backButton, 5*CA_H_RATIO_WIDTH);

    [backButton addTarget: self action: @selector(ca_backAction) forControlEvents: UIControlEventTouchUpInside];

    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];

    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;

    self.navigationItem.leftBarButtonItems = @[spaceItem, backItem];
    
}

/**
 无网络时展示的页面
 */
- (void)showNoNetwork{
    UIButton* reloadBtn = [[UIButton alloc] init];
    [reloadBtn configTitle:@"重新加载" titleColor:CA_H_TINTCOLOR font:34];
    [reloadBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

/**
 隐藏无网络时展示的页面
 */
- (void)hiddenNoNetwork{
    
}



#pragma mark --- Action

- (void)ca_backAction{
    // 在这里增加返回按钮的自定义动作
    
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (!vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return (self.navigationController.viewControllers.count > 1);
}


/**
 无网络时重新加载
 */
- (void)reloadData{
    
}

- (void)resignFirstResponder{
    [self.view endEditing:YES];
}
@end
