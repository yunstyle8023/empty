
//
//  CA_MDiscoverRelatedProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedProjectVC.h"
#import "CA_MDiscoverRelatedProjecViewModel.h"
#import "CA_MDiscoverRelatedProjecViewManager.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverRelatedProjectVC ()
<UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverRelatedProjecViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverRelatedProjecViewModel *viewModel;
@end

@implementation CA_MDiscoverRelatedProjectVC

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
    self.viewManager.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RelatedProductCell";
    CA_MDiscoverProjectDetailRelatedProductCell *relatedCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    relatedCell.model = self.viewModel.dataSource[indexPath.row];
    CA_H_WeakSelf(self)
    relatedCell.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
        CA_H_StrongSelf(self)
      NSLog(@"点击了第%ld个标签---%@",(long)indexPath.item,tagName);
    };
    [relatedCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return relatedCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    CA_MDiscoverCompatible_project_list *model = self.viewModel.dataSource[indexPath.row];
    projectDetailVC.dataID = model.data_id;
    [self.navigationController pushViewController:projectDetailVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailRelatedProductCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        UIView *header = [UIView new];
        header.backgroundColor = kColor(@"#FFFFFF");
        header;
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

-(CA_MDiscoverRelatedProjecViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverRelatedProjecViewManager new];
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

-(CA_MDiscoverRelatedProjecViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverRelatedProjecViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.dataID = self.dataID;
        _viewModel.data_type = self.data_type;
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
