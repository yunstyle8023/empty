
//
//  CA_MDiscoverSponsorListVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorListVC.h"
#import "CA_MDiscoverSponsorListViewManager.h"
#import "CA_MDiscoverSponsorListViewModel.h"
#import "CA_MDiscoverSponsorCell.h"
#import "CA_MDiscoverSponsorListModel.h"
#import "CA_MDiscoverProjectDetailTagSectionHeaderView.h"
#import "CA_MDiscoverSponsorDetailVC.h"
#import "CA_MDiscoverSponsorModel.h"

@interface CA_MDiscoverSponsorListVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverSponsorListViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverSponsorListViewModel *viewModel;

@end

@implementation CA_MDiscoverSponsorListVC

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

- (void)upView {
    self.navigationItem.title = self.tag;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = self.viewModel.listModel.data_list.count==0;
    return self.viewModel.listModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverSponsorCell *sponsorCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorCell"];
    sponsorCell.model = self.viewModel.listModel.data_list[indexPath.row];
    [sponsorCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return sponsorCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverSponsorData_list *model = self.viewModel.listModel.data_list[indexPath.row];
    CA_MDiscoverSponsorDetailVC *sponsorDetailVC = [CA_MDiscoverSponsorDetailVC new];
    sponsorDetailVC.data_id = model.data_id;
    [self.navigationController pushViewController:sponsorDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverSponsorCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverProjectDetailTagSectionHeaderView *header = [CA_MDiscoverProjectDetailTagSectionHeaderView new];
        header.title = @"条出资人";
        if (![NSObject isValueableObject:self.viewModel.listModel.data_list]) {
            header = nil;
        }else{
            header.count = self.viewModel.listModel.total_count;
        }
        header;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (![NSObject isValueableObject:self.viewModel.listModel.data_list]) {
        return CGFLOAT_MIN;
    }
    return 21*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(CA_MDiscoverSponsorListViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverSponsorListViewManager new];
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

-(CA_MDiscoverSponsorListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverSponsorListViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.tag = self.tag;
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
            
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}

@end
