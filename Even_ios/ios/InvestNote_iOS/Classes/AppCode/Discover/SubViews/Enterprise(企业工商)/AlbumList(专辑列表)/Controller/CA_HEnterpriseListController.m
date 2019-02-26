//
//  CA_HEnterpriseListController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HEnterpriseListController.h"

#import "CA_HEnterpriseListModelManager.h"
#import "CA_HEnterpriseListViewManager.h"

#import "CA_HFoundSearchController.h"//搜索
#import "CA_HAlbumDetailsController.h"//专辑详情

@interface CA_HEnterpriseListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HEnterpriseListModelManager *modelManager;
@property (nonatomic, strong) CA_HEnterpriseListViewManager *viewManager;

@end

@implementation CA_HEnterpriseListController

#pragma mark --- Action

- (void)onSearch:(UIButton *)sender {
    
    CA_HFoundSearchController *searchVC = [CA_HFoundSearchController new];
    searchVC.modelManager.type = CA_HFoundSearchTypeEnterprise;
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:searchVC] animated:YES completion:^{
        
    }];
}

#pragma mark --- Lazy

- (CA_HEnterpriseListModelManager *)modelManager {
    if (!_modelManager) {
        CA_HEnterpriseListModelManager *modelManager = [CA_HEnterpriseListModelManager new];
        _modelManager = modelManager;
    }
    return _modelManager;
}

- (CA_HEnterpriseListViewManager *)viewManager {
    if (!_viewManager) {
        CA_HEnterpriseListViewManager *viewManager = [CA_HEnterpriseListViewManager new];
        _viewManager = viewManager;
        
        [viewManager searchView:self action:@selector(onSearch:)];
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

#pragma mark --- Custom

- (void)upView {
    
    self.title = self.modelManager.title;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    
    self.viewManager.tableView.scrollEnabled = NO;
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"xiaotieshi"];
    [self.view addSubview:imageView];
    imageView.sd_layout
    .widthIs(315*CA_H_RATIO_WIDTH)
    .heightIs(338*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 95*CA_H_RATIO_WIDTH);
    
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 36*CA_H_RATIO_WIDTH;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = self.viewManager.headerView;
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[CA_HAlbumDetailsController new] animated:YES];
}

@end
