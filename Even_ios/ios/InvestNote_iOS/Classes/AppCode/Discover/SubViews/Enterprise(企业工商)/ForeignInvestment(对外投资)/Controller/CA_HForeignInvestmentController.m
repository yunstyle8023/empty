//
//  CA_HForeignInvestmentController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HForeignInvestmentController.h"

#import "CA_HForeignInvestmentViewManager.h"

#import "CA_HForeignInvestmentCell.h"

@interface CA_HForeignInvestmentController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HForeignInvestmentViewManager *viewManager;

@end

@implementation CA_HForeignInvestmentController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HForeignInvestmentModelManager *)modelManager {
    if (!_modelManager) {
        CA_HForeignInvestmentModelManager *modelManager = [CA_HForeignInvestmentModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.finishBlock = ^(BOOL noMore) {
            CA_H_StrongSelf(self);
            
            [self.viewManager.tableView.mj_header endRefreshing];
            if (noMore) {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.viewManager.tableView.mj_footer endRefreshing];
            }
            
            [self.viewManager.tableView reloadData];
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _modelManager;
}

- (CA_HForeignInvestmentViewManager *)viewManager {
    if (!_viewManager) {
        CA_HForeignInvestmentViewManager *viewManager = [CA_HForeignInvestmentViewManager new];
        _viewManager = viewManager;
        
        CA_H_WeakSelf(self);
        viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore:@(1)];
        }];
        
        viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore:@(self.modelManager.model.page_num.integerValue+1)];
        }];
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadMore:@(1)];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *backView = self.viewManager.tableView.backgroundView.subviews.firstObject;
    if (backView.centerX > 0) {
        backView.sd_closeAutoLayout = YES;
        backView.mj_y = -scrollView.contentOffset.y;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView.hidden = (self.modelManager.data.count>0);
    return self.modelManager.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HForeignInvestmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.model = self.modelManager.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
