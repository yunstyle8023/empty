//
//  CA_MDiscoverVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverVC.h"
#import "CA_MDiscoverViewManager.h"
#import "CA_MDiscoverViewModel.h"
#import "CA_MDiscoverCell.h"
#import "CA_MDiscoverTitleView.h"
#import "CA_MDiscoverTableHeaderView.h"
#import "CA_MDiscoverProjectVC.h"//项目信息
#import "CA_HEnterpriseListController.h"// 企业工商
#import "CA_MDiscoverSponsorVC.h"//出资人
#import "CA_MDiscoverInvestmentVC.h"//投资机构
#import "CA_MDiscoverFinancingVC.h"//融资事件
#import "CA_HFoundReportController.h"//行研报告
#import "CA_HFoundAggregateSearchController.h"
#import "CA_MDiscoverModel.h"
#import "CA_MDiscoverProjectDetailVC.h"

@interface CA_MDiscoverVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,strong) CA_MDiscoverViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverViewModel *viewModel;
@end

@implementation CA_MDiscoverVC

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

-(void)upView{
    self.navigationItem.titleView = self.viewManager.titleView;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(5*2*CA_H_RATIO_WIDTH, 0, 0, 0 ));
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = self.viewModel.discoverModel.data_list.count==0;
    return self.viewModel.discoverModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverCell *discoverCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"];
    discoverCell.model = self.viewModel.discoverModel.data_list[indexPath.row];
    [discoverCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return discoverCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    CA_MCommonModel *model = self.viewModel.discoverModel.data_list[indexPath.row];
    projectDetailVC.dataID = model.project_id;
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MCommonModel *model = self.viewModel.discoverModel.data_list[indexPath.row];
    return [self.viewManager.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_MDiscoverCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.viewManager.sectionHeaderView.hidden = self.viewModel.discoverModel.data_list.count == 0;
    return self.viewManager.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42.f*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter
-(CA_MDiscoverViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.titleView.jumpBlock = ^{
            CA_H_StrongSelf(self)
            CA_HFoundAggregateSearchController *searchVC = [CA_HFoundAggregateSearchController new];
            [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:searchVC] animated:YES completion:^{
                
            }];
        };
        _viewManager.pushBlock = ^(NSIndexPath *indexPath,CA_MModuleModel *model) {
            CA_H_StrongSelf(self)
            
            UIViewController *vc = nil;
            switch (indexPath.item) {
                case 0:{
                    CA_MDiscoverProjectVC *projectVC = [CA_MDiscoverProjectVC new];
                    projectVC.model = model;
                    vc = projectVC;
                }break;
                case 1:{
                    CA_HEnterpriseListController *enterpriseVC = [CA_HEnterpriseListController new];
                    vc = enterpriseVC;
                }break;
                case 2:{
                    CA_MDiscoverSponsorVC *sponsorVC = [CA_MDiscoverSponsorVC new];
                    vc = sponsorVC;
                }break;
                case 3:{
                    CA_MDiscoverInvestmentVC *investmentVC = [CA_MDiscoverInvestmentVC new];
                    vc = investmentVC;
                }break;
                case 4:{
                    CA_MDiscoverFinancingVC *financingVC = [CA_MDiscoverFinancingVC new];
                    vc = financingVC;
                }break;
                case 5:{
                    CA_HFoundReportController *reportVC = [CA_HFoundReportController new];
                    vc = reportVC;
                }break;
                default:
                    break;
            }
            
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
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
-(CA_MDiscoverViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.data_type = @"investment";
        _viewModel.search_str = @"latest";
        _viewModel.search_type = @"latest";
        CA_H_WeakSelf(self);
        _viewModel.finishedBlock = ^(BOOL isLoadMore,BOOL isHasData) {
            CA_H_StrongSelf(self)
            
            if (!isLoadMore) {
                [self.viewManager.tableView.mj_header endRefreshing];
            }
            
            if (!isHasData) {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.viewManager.tableView.mj_footer endRefreshing];
            }
            
            self.viewManager.headerView.dataList = self.viewModel.discoverModel.modules_list;
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}


@end
