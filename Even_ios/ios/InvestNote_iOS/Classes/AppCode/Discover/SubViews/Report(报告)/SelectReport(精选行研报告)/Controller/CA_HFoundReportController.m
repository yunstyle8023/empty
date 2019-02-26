//
//  CA_HFoundReportController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundReportController.h"

#import "CA_HFoundReportModelManager.h"
#import "CA_HFoundReportViewManager.h"

#import "CA_HBaseTableCell.h"

#import "CA_HSearchReportController.h"//搜索

#import "CA_HBorwseFileManager.h"//浏览

@interface CA_HFoundReportController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HFoundReportModelManager *modelManager;
@property (nonatomic, strong) CA_HFoundReportViewManager *viewManager;

@end

@implementation CA_HFoundReportController

#pragma mark --- Action

- (void)onSearch:(UIButton *)sender {
    
    CA_HSearchReportController *searchVC = [CA_HSearchReportController new];
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:searchVC] animated:YES completion:^{
        
    }];
}

#pragma mark --- Lazy

- (CA_HFoundReportModelManager *)modelManager {
    if (!_modelManager) {
        CA_HFoundReportModelManager *modelManager = [CA_HFoundReportModelManager new];
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

- (CA_HFoundReportViewManager *)viewManager {
    if (!_viewManager) {
        CA_HFoundReportViewManager *viewManager = [CA_HFoundReportViewManager new];
        _viewManager = viewManager;
        
        [viewManager searchView:self action:@selector(onSearch:)];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadMore:@(1)];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
    [self.viewManager.tableView reloadData];
}

#pragma mark --- Custom

- (void)upView {
    
    self.title = self.modelManager.title;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelManager.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.modelManager.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HFoundReportData *model = self.modelManager.data[indexPath.row];
    [CA_HBorwseFileManager browseReport:model controller:self];
}

@end
