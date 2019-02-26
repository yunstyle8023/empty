
//
//  CA_MDiscoverSponsorVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorVC.h"
#import "CA_MDiscoverSponsorViewManager.h"
#import "CA_MDiscoverSponsorViewModel.h"
#import "CA_MDiscoverSponsorCell.h"
#import "CA_HFoundSearchController.h"
#import "CA_MDiscoverSponsorChangeView.h"
#import "CA_MDiscoverSponsorDetailVC.h"
#import "CA_MDiscoverSponsorModel.h"
#import "CA_HNoteListTebleView.h"
#import "CA_MDiscoverSponsorHeaderView.h"
#import "CA_MDiscoverGovernmentFundsVC.h"

@interface CA_MDiscoverSponsorVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverSponsorViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverSponsorViewModel *viewModel;

@end

@implementation CA_MDiscoverSponsorVC

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

- (void)upView {
    self.navigationItem.title = @"查找出资人";
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    [self.view addSubview:self.viewManager.changeView];
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
-(CA_MDiscoverSponsorViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverSponsorViewManager new];
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
        _viewManager.headView.listTableView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self)
            CA_HFoundSearchController *searchVC = [CA_HFoundSearchController new];
            searchVC.modelManager.type = CA_HFoundSearchTypeLp;
            [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:searchVC] animated:YES completion:^{
                
            }];
        } ;
        _viewManager.headView.jumpBlock = ^{
            CA_H_StrongSelf(self)
            CA_MDiscoverGovernmentFundsVC *governmentFundsVC = [CA_MDiscoverGovernmentFundsVC new];
            [self.navigationController pushViewController:governmentFundsVC animated:YES];
        };
        _viewManager.changeBlock = ^{
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock();
        };
    }
    return _viewManager;
}
-(CA_MDiscoverSponsorViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverSponsorViewModel new];
        self.viewModel.type = @"random";
        _viewModel.loadingView = self.viewManager.tableView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore, BOOL isHasData) {
            CA_H_StrongSelf(self)
            
            self.viewManager.headView.titleLb.text = [NSString stringWithFormat:@"特别推荐：政府引导基金 %@ 条记录",self.viewModel.investor_recommend_count];
            
            self.viewManager.changeView.hidden = NO;
            
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
