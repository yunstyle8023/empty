
//
//  CA_MDiscoverProjectDetailTagVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailTagVC.h"
#import "CA_MDiscoverProjectDetailTagViewManager.h"
#import "CA_MDiscoverProjectDetailTagViewModel.h"
#import "CA_MDiscoverProjectDetailTagSectionHeaderView.h"
#import "CA_MDiscoverProjectDetailTagCell.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverProjectDetailTagModel.h"

@interface CA_MDiscoverProjectDetailTagVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverProjectDetailTagViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverProjectDetailTagViewModel *viewModel;
@end

@implementation CA_MDiscoverProjectDetailTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

-(void)upView{
    self.navigationItem.title = self.tagName;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
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

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverProjectDetailTagCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    if ([NSObject isValueableObject:self.viewModel.dataSource]) {
        if (indexPath.row <= self.viewModel.dataSource.count-1) {
            tagCell.model = self.viewModel.dataSource[indexPath.row];
        }
    }
    [tagCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return tagCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    if ([NSObject isValueableObject:self.viewModel.dataSource]) {
        if (indexPath.row <= self.viewModel.dataSource.count-1) {
            CA_MDiscoverProjectDetailTagModel *model = self.viewModel.dataSource[indexPath.row];
            projectDetailVC.dataID = model.data_id;
        }
    }
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailTagCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverProjectDetailTagSectionHeaderView *header = [CA_MDiscoverProjectDetailTagSectionHeaderView new];
        header.title = @"个项目";
        if (![NSObject isValueableObject:self.viewModel.dataSource]) {
            header = nil;
        }else{
            header.count = self.viewModel.total_count;
        }
        header;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (![NSObject isValueableObject:self.viewModel.dataSource]) {
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

-(CA_MDiscoverProjectDetailTagViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverProjectDetailTagViewManager new];
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

-(CA_MDiscoverProjectDetailTagViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverProjectDetailTagViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.tagName = self.tagName;
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
