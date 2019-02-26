//
//  CA_MProjectTraceDynamicVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceDynamicVC.h"
#import "CA_MProjectTraceDynamicViewManager.h"
#import "CA_MProjectTraceDynamicViewModel.h"
#import "CA_MProjectInvestDynamicCell.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MDiscoverInvestmentDetailVC.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverProjectH5VC.h"
#import "CA_HBaseModel.h"
#import "ButtonLabel.h"
#import "CA_MProjectTraceInvestedModel.h"

@interface CA_MProjectTraceDynamicVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MProjectTraceDynamicViewManager *viewManager;

@property (nonatomic,strong) CA_MProjectTraceDynamicViewModel *viewModel;

@end

@implementation CA_MProjectTraceDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
}

-(void)upView{
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.urlStr isEqualToString:CA_M_Api_ListInvestorDynamic]) {
        CA_MProjectInvestDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
        dynamicCell.model = self.viewModel.dataSource[indexPath.row];
        CA_H_WeakSelf(self)
        __weak CA_MProjectTraceInvestedModel*weakModel = self.viewModel.dataSource[indexPath.row];
        dynamicCell.investorLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverInvestmentDetailVC *investmentVC = [CA_MDiscoverInvestmentDetailVC new];
            investmentVC.data_id = weakModel.investor_id;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self.navigationController pushViewController:investmentVC animated:YES];
            });
        };
        dynamicCell.investoredLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
            projectDetailVC.dataID = weakModel.invested_id;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self.navigationController pushViewController:projectDetailVC animated:YES];
            });
        };
        dynamicCell.newsLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
            h5VC.urlStr = weakModel.news_url;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self.navigationController pushViewController:h5VC animated:YES];
            });
        };
        return dynamicCell;
    }
    CA_MDiscoverProjectDetailNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    newsCell.model = self.viewModel.dataSource[indexPath.row];
    return newsCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_HBaseModel *model = self.viewModel.dataSource[indexPath.row];
    
    if ([self.urlStr isEqualToString:CA_M_Api_ListInvestorDynamic]) {
        
    }else {
        CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
        h5VC.urlStr = [model valueForKey:@"news_url"];
        CA_H_DISPATCH_MAIN_THREAD(^{
            [self.navigationController pushViewController:h5VC animated:YES];
        });
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.urlStr isEqualToString:CA_M_Api_ListInvestorDynamic]) {
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MProjectInvestDynamicCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailNewsCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.urlStr isEqualToString:CA_M_Api_ListInvestorDynamic]) return 7*2*CA_H_RATIO_WIDTH;
    return 2*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(CA_MProjectTraceDynamicViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MProjectTraceDynamicViewManager new];
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

-(CA_MProjectTraceDynamicViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MProjectTraceDynamicViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.project_id = self.project_id;
        _viewModel.urlStr = self.urlStr;
        _viewModel.modelClass = self.modelClass;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore, BOOL isHasData) {
            CA_H_StrongSelf(self)
            if (!isLoadMore) {
                [self.viewManager.tableView.mj_header endRefreshing];
            }
            if (!isHasData) {
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














