//
//  CA_MDiscoverSponsorItemInvestVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemInvestVC.h"
#import "CA_MDiscoverSponsorItemInvestViewManager.h"
#import "CA_MDiscoverSponsorItemInvestViewModel.h"
#import "CA_MDiscoverSponsorItemInvestModel.h"
#import "CA_MDiscoverSponsorItemInvestCell.h"

@interface CA_MDiscoverSponsorItemInvestVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverSponsorItemInvestViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverSponsorItemInvestViewModel *viewModel;

@end

@implementation CA_MDiscoverSponsorItemInvestVC


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
    self.navigationItem.title = self.viewModel.title;
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
    CA_MDiscoverSponsorItemInvestCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"ItemInvestCell"];
    itemCell.model = self.viewModel.listModel.data_list[indexPath.row];
    [itemCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return itemCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverSponsorItemInvestCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        UIView *view = [UIView new];
        view.backgroundColor = kColor(@"#FFFFFF");
        view;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(CA_MDiscoverSponsorItemInvestViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverSponsorItemInvestViewManager new];
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

-(CA_MDiscoverSponsorItemInvestViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverSponsorItemInvestViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.lpId = self.lpId;
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
