//
//  CA_MDiscoverProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectVC.h"
#import "CA_MDiscoverProjectViewManager.h"
#import "CA_MDiscoverViewModel.h"
#import "CA_MDiscoverProjectCell.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_HFoundSearchController.h"
#import "CA_MDiscoverModel.h"

@interface CA_MDiscoverProjectVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,strong) CA_MDiscoverProjectViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverViewModel *viewModel;

@end

@implementation CA_MDiscoverProjectVC

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
    self.navigationItem.title = self.model.module_name;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = self.viewModel.discoverModel.data_list.count==0;
    return self.viewModel.discoverModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *key = @"DiscoverProjectCell";
    CA_MDiscoverProjectCell *projectCell = [tableView dequeueReusableCellWithIdentifier:key];
    projectCell.model = self.viewModel.discoverModel.data_list[indexPath.row];
    [projectCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return projectCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MCommonModel *model = self.viewModel.discoverModel.data_list[indexPath.row];
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    projectDetailVC.dataID = model.project_id;
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MCommonModel *model = self.viewModel.discoverModel.data_list[indexPath.row];
    return [self.viewManager.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_MDiscoverProjectCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        UIView *sectionHeadView = [UIView new];
        sectionHeadView.backgroundColor = kColor(@"#FFFFFF");
        sectionHeadView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.f*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter
-(CA_MDiscoverProjectViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverProjectViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.jumpBlock = ^{
            CA_H_StrongSelf(self)
            CA_HFoundSearchController *searchVC = [CA_HFoundSearchController new];
            searchVC.modelManager.type = CA_HFoundSearchTypeProject;
            
            [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:searchVC] animated:YES completion:^{
                
            }];
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
        _viewModel.data_type = @"investment";
        _viewModel.search_str = @"latest";
        _viewModel.search_type = @"latest";
        CA_H_WeakSelf(self)
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
