
//
//  CA_MDiscoverProjectDetailCorePersonVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailCorePersonVC.h"
#import "CA_MDiscoverProjectDetailCorePersonViewManager.h"
#import "CA_MDiscoverProjectDetailCorePersonViewModel.h"
#import "CA_MDiscoverProjectDetailCorePersonCell.h"
#import "CA_MDiscoverRelatedPersonVC.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverProjectDetailCorePersonVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverProjectDetailCorePersonViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverProjectDetailCorePersonViewModel *viewModel;

@end

@implementation CA_MDiscoverProjectDetailCorePersonVC

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
    CA_MDiscoverProjectDetailCorePersonCell *corePersonCell = [tableView dequeueReusableCellWithIdentifier:@"CorePersonCell"];
    corePersonCell.model = self.viewModel.dataSource[indexPath.row];
    CA_H_WeakSelf(self)
    corePersonCell.nameLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
        relatedPersonVC.enterprise_str = self.enterprise_str;
        relatedPersonVC.personName = ((CA_MDiscoverMember_list *)self.viewModel.dataSource[indexPath.row]).member_name;
        [self.navigationController pushViewController:relatedPersonVC animated:YES];
        
    };
    [corePersonCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return corePersonCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailCorePersonCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
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

-(CA_MDiscoverProjectDetailCorePersonViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverProjectDetailCorePersonViewManager new];
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

-(CA_MDiscoverProjectDetailCorePersonViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverProjectDetailCorePersonViewModel new];
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
