
//
//  CA_MDiscoverInvestmentCommerceVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentCommerceVC.h"
#import "CA_MDiscoverInvestmentCommerceViewManager.h"
#import "CA_MDiscoverInvestmentCommerceViewModel.h"
#import "CA_MDiscoverInvestmentCommerceCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "CA_HBusinessDetailsController.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentCommerceVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverInvestmentCommerceViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverInvestmentCommerceViewModel *viewModel;

@end

@implementation CA_MDiscoverInvestmentCommerceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)upView {
    self.navigationItem.title = self.viewModel.title;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverInvestmentCommerceCell *commerceCell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCommerceCell"];
    CA_MDiscoverInvestmentBusiness_TraceModel *model = self.viewModel.dataSource[indexPath.row];
    commerceCell.model = model;
    CA_H_WeakSelf(self)
    __weak CA_MDiscoverInvestmentBusiness_TraceModel *weakModel = model;
    commerceCell.titleLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
        vc.modelManager.dataStr = weakModel.invest_enterprise;
        [self.navigationController pushViewController:vc animated:YES];
    };
    commerceCell.companyLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
        vc.modelManager.dataStr = weakModel.invested_enterprise;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [commerceCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return commerceCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverInvestmentCommerceCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

#pragma mark - getter and setter

-(CA_MDiscoverInvestmentCommerceViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverInvestmentCommerceViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.refreshBlock();
        }];
        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.loadMoreBlock();
        }];
    }
    return _viewManager;
}

-(CA_MDiscoverInvestmentCommerceViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverInvestmentCommerceViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.gp_id = self.data_id;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore, BOOL isHasData) {
            CA_H_StrongSelf(self)
            if (!isLoadMore) {
                [self.viewManager.tableView.mj_header endRefreshing];
            }
            if (isHasData) {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.viewManager.tableView.mj_footer endRefreshing];
            }
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}

@end
