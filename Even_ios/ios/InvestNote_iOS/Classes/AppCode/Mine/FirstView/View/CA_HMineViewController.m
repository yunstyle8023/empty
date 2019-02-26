//
//  CA_HMineViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineViewController.h"

#import "CA_HMineViewModel.h"
#import "CA_HMineViewManager.h"

#import "CA_HBaseTableCell.h"

#import "CA_HDownloadCenterViewController.h" //下载中心
#import "CA_HSettingsViewController.h" //设置
#import "CA_HStatisticsViewController.h"

#import "CA_MMessageVC.h"
#import "CA_MMyApproveVC.h"
#import "CA_MMyBaseInfoVC.h"

@interface CA_HMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HMineViewModel *viewModel;
@property (nonatomic, strong) CA_HMineViewManager *viewManager;

@end

@implementation CA_HMineViewController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HMineViewModel *)viewModel {
    if (!_viewModel) {
        CA_HMineViewModel *viewModel = [CA_HMineViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.model.finishRequestBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            CA_H_DISPATCH_MAIN_THREAD(^{
                if (success) {
                    CA_H_MANAGER.tabbarPoint.hidden = !(self.viewModel.model.approval_count.integerValue+self.viewModel.model.message_count.integerValue);
                    [self.viewManager.tableView reloadData];
                }
            });
        };
    }
    return _viewModel;
}

- (CA_HMineViewManager *)viewManager {
    if (!_viewManager) {
        CA_HMineViewManager *viewManager = [CA_HMineViewManager new];
        _viewManager = viewManager;
    }
    return _viewManager;
}


#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if (CA_H_MANAGER.getToken.length) {
        [self.viewModel.model loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    
    self.viewManager.tableView.dataSource = self;
    self.viewManager.tableView.delegate = self;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 119*CA_H_RATIO_WIDTH;
//        case 1:
//            return 183*CA_H_RATIO_WIDTH;
        default:
            return 53*CA_H_RATIO_WIDTH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"info";
            break;
//        case 1:
//            identifier = @"count";
//            break;
        default:
            identifier = @"cell";
            break;
    }
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.textLabel.text = self.viewModel.data[indexPath.row];
    cell.imageView.image = kImage(self.viewModel.imgs[indexPath.row]);
    switch (indexPath.row) {
        case 0:
            cell.model = self.viewModel.model.user_info;
            break;
//        case 1:
//            cell.model = self.viewModel.model;
//            break;
        case 1:
            cell.model = self.viewModel.model.approval_count;
            break;
        case 3:
            cell.model = self.viewModel.model.message_count;
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [CA_MMyBaseInfoVC new];
            [vc setValue:self.viewModel.model.user_info forKey:@"userInfo"];
            break;
//        case 1:
//            vc = [CA_HStatisticsViewController new];
//            break;
        case 1:
            vc = [CA_MMyApproveVC new];
            break;
        case 2:
            vc = [CA_HDownloadCenterViewController new];
            break;
        case 3:
            vc = [CA_MMessageVC new];
            break;
        case 4:
            vc = [CA_HSettingsViewController new];
            break;
        default:
            vc = [CA_HBaseViewController new];
            vc.title = @"暂无";
            break;
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
