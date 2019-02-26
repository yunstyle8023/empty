
//
//  CA_MDiscoverRelatedNewsVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedNewsVC.h"
#import "CA_MDiscoverRelatedNewsViewManager.h"
#import "CA_MDiscoverRelatedNewsViewModel.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MDiscoverProjectH5VC.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverRelatedNewsVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverRelatedNewsViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverRelatedNewsViewModel *viewModel;

@end

@implementation CA_MDiscoverRelatedNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

-(void)upView{
    self.navigationItem.title = self.viewModel.title;
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
    CA_MDiscoverProjectDetailNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    newsCell.model = self.viewModel.dataSource[indexPath.row];
    [newsCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return newsCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverNews_list *model = self.viewModel.dataSource[indexPath.row];
    CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
    h5VC.urlStr = model.news_url;
    [self.navigationController pushViewController:h5VC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailNewsCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
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

-(CA_MDiscoverRelatedNewsViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverRelatedNewsViewManager new];
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

-(CA_MDiscoverRelatedNewsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverRelatedNewsViewModel new];
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
