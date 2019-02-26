//
//  CA_MDiscoverGovernmentFundsVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverGovernmentFundsVC.h"
#import "CA_MDiscoverGovernmentFundsViewManager.h"
#import "CA_MDiscoverGovernmentFundsViewModel.h"
#import "CA_MDiscoverGovernmentFundsTopView.h"
#import "CA_MDiscoverGovernmentFundsSectionView.h"
#import "CA_MDiscoverSponsorCell.h"
#import "CA_MDiscoverSponsorDetailVC.h"
#import "CA_MDiscoverSponsorModel.h"

@interface CA_MDiscoverGovernmentFundsVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverGovernmentFundsViewManager *viewManager;

@property (nonatomic,strong) CA_MDiscoverGovernmentFundsViewModel *viewModel;

@end

@implementation CA_MDiscoverGovernmentFundsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated{
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillDisappear:animated];
}

-(void)upView{
    
    self.navigationItem.title = self.viewModel.title;
    
    [self.view addSubview:self.viewManager.topView];
    self.viewManager.topView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH)
    .heightIs((18+8+1)*2*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, (18+8+1)*2*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH);
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverSponsorCell *sponsorCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorCell"];
    sponsorCell.model = self.viewModel.dataSource[indexPath.row];
    [sponsorCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return sponsorCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverSponsorDetailVC *sponsorDetailVC = [CA_MDiscoverSponsorDetailVC new];
    sponsorDetailVC.data_id = ((CA_MDiscoverSponsorData_list *)self.viewModel.dataSource[indexPath.row]).data_id;
    [self.navigationController pushViewController:sponsorDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverSponsorCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverGovernmentFundsSectionView *headerView = [CA_MDiscoverGovernmentFundsSectionView new];
        headerView.totalCount = self.viewModel.total_count;
        headerView.hidden = self.viewModel.dataSource.count==0;
        headerView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(CA_MDiscoverGovernmentFundsViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverGovernmentFundsViewManager new];
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
        _viewManager.topView.didSelectedItem = ^(NSString *itemCode){
            CA_H_StrongSelf(self)
            self.viewModel.search_type = itemCode;
            self.viewModel.loadDataBlock();
        };
    }
    return _viewManager;
}

-(CA_MDiscoverGovernmentFundsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverGovernmentFundsViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.data_type = @"governmentguidefund";
        _viewModel.search_type = @"all";
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore, BOOL isHasData) {
            CA_H_StrongSelf(self)

            self.viewManager.tableView.backgroundView.hidden = [NSObject isValueableObject:self.viewModel.dataSource];
            
            if (!isHasData) {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.viewManager.tableView.mj_footer endRefreshing];
            }
            
            [self.viewManager.tableView.mj_header endRefreshing];
            
            [self.viewManager.tableView reloadData];
            
            if (self.viewModel.isShowLoading) {
                [self.viewManager.tableView scrollToTop];
            }
        };
    }
    return _viewModel;
}

@end







