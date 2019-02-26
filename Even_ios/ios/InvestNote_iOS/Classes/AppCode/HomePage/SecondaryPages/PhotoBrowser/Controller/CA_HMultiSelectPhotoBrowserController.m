//
//  CA_HMultiSelectPhotoBrowserController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMultiSelectPhotoBrowserController.h"

@interface CA_HMultiSelectPhotoBrowserController ()

@end

@implementation CA_HMultiSelectPhotoBrowserController

#pragma mark --- Action

- (void)ca_backAction{
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --- LifeCircle

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upNavigationBackButtonItem];
    [self upView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.subviews.count == 0) {
        [self.viewModel showPhotoBrowser:self.view];
    }
}

#pragma mark --- Custom

- (void)upView{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = CA_H_LAN(@"预览");
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItem;
    
}


/**
 更新nav返回按钮
 */
- (void)upNavigationBackButtonItem{
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame = CGRectMake(15, 5, 38, 38);
    
    [backButton setImage:[UIImage imageNamed:@"icons_back"] forState:UIControlStateNormal];
    
    [backButton addTarget: self action: @selector(ca_backAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.navigationItem.leftBarButtonItems = @[spaceItem, backItem];
    
}

@end
