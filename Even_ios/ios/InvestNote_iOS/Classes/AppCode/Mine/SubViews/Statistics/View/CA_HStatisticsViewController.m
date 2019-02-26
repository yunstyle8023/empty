//
//  CA_HStatisticsViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HStatisticsViewController.h"

#import "CA_HStatisticsViewModel.h"
#import "CA_HStatisticsViewManager.h"

@interface CA_HStatisticsViewController ()

@property (nonatomic, strong) CA_HStatisticsViewModel *viewModel;
@property (nonatomic, strong) CA_HStatisticsViewManager *viewManager;

@end

@implementation CA_HStatisticsViewController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HStatisticsViewModel *)viewModel {
    if (!_viewModel) {
        CA_HStatisticsViewModel *viewModel = [CA_HStatisticsViewModel new];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (CA_HStatisticsViewManager *)viewManager {
    if (!_viewManager) {
        CA_HStatisticsViewManager *viewManager = [CA_HStatisticsViewManager new];
        _viewManager = viewManager;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

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
                           opacity:0.];
    [super viewWillAppear:animated];
}

- (void)ca_layoutContentView {
    [super ca_layoutContentView];
    
    [self customScrollView];
}

// 滚动分页
- (NSArray *)scrollViewTitles {
    return self.viewModel.data;
}
- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    return [self.viewManager contentViewWithItem:item];
}

#pragma mark --- Custom

- (void)upView{
    self.title = self.viewModel.title;
}

#pragma mark --- Delegate

@end
