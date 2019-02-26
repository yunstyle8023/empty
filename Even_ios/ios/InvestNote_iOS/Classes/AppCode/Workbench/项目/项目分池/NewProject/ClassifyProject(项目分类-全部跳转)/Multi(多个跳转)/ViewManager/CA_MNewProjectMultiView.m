
//
//  CA_MNewProjectMultiTableView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectMultiView.h"
#import "CA_MNewProjectNoTagCell.h"
#import "CA_MNewProjectTagCell.h"
#import "CA_MNewProjectPlanItemCell.h"
#import "CA_MNewProjectAlreadyItemCell.h"
#import "CA_MNewProjectAbandonCell.h"
#import "CA_MNewProjectQuitCell.h"
#import "CA_HNullView.h"
#import "CA_MNewProjectSingleViewModel.h"
#import "CA_MNewProjectListModel.h"
#import "CA_MNewProjectContentVC.h"
#import "CA_MProjectModel.h"
#import "CA_MEmptyView.h"

@interface CA_MNewProjectMultiView ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSNumber *pool_id;

@property (nonatomic,strong) NSNumber *tag_id;

@end

@implementation CA_MNewProjectMultiView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tableView];
        self.tableView.sd_resetLayout
        .spaceToSuperView(UIEdgeInsetsZero);

    }
    return self;
}

-(void)configViewWithPool_id:(NSNumber *)pool_id
                      tag_id:(NSNumber *)tag_id{
    self.pool_id = pool_id;
    self.tag_id = tag_id;
}

-(void)resetLayout:(BOOL)isRecover{
    [self addSubview:self.tableView];
    self.tableView.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake((isRecover?8:8+25*2*CA_H_RATIO_WIDTH), 0, 0, 0));
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.viewModel.isFinished ) {
        [self.viewModel listModel];
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.backgroundView.hidden = [NSObject isValueableObject:self.viewModel.listModel.data_list];
    self.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.listModel.data_list];
    return self.viewModel.listModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
//    if (self.pool_id.intValue == 15 ) {//关注项目
//
//    }else
    if (self.pool_id.intValue == 1) {//储备项目
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectNoTagCell"];
        ((CA_MNewProjectNoTagCell *)cell).model = self.viewModel.listModel.data_list[indexPath.row];
        return cell;
    }else if (self.pool_id.intValue == 5) {//拟投项目
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectPlanItemCell"];
        ((CA_MNewProjectPlanItemCell *)cell).model = (id)self.viewModel.listModel.data_list[indexPath.row];
        return cell;
    }else if (self.pool_id.intValue == 8) {//已投项目
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectAlreadyItemCell"];
        ((CA_MNewProjectAlreadyItemCell *)cell).model = (id)self.viewModel.listModel.data_list[indexPath.row];
        return cell;
    }else if (self.pool_id.intValue == 10) {//退出项目
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectQuitCell"];
        ((CA_MNewProjectQuitCell *)cell).model = (id)self.viewModel.listModel.data_list[indexPath.row];
        return cell;
    }else if (self.pool_id.intValue == 13) {//放弃项目
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectAbandonCell"];
        ((CA_MNewProjectAbandonCell *)cell).model = (id)self.viewModel.listModel.data_list[indexPath.row];
        return cell;
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [self currentViewController];
    
    if (vc) {
        CA_H_WeakSelf(self)
        CA_MNewProjectContentVC* projectDetailVC = [[CA_MNewProjectContentVC alloc] init];
        CA_MProjectModel *model = self.viewModel.listModel.data_list[indexPath.row];
        projectDetailVC.pId = model.project_id;
        projectDetailVC.refreshBlock = ^(NSNumber *ids){
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock();
            [CA_H_NotificationCenter postNotificationName:CA_M_RefreshProjectListNotification object:nil];
        };
        [vc.navigationController pushViewController:projectDetailVC animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pool_id.intValue == 1) {//储备项目
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectNoTagCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (self.pool_id.intValue == 5) {//拟投项目
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectPlanItemCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (self.pool_id.intValue == 8) {//已投项目
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectAlreadyItemCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (self.pool_id.intValue == 10) {//退出项目
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectQuitCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (self.pool_id.intValue == 13) {//放弃项目
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectAbandonCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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


- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

#pragma mark - getter and setter

-(CA_MNewProjectSingleViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewProjectSingleViewModel new];
        _viewModel.loadingView = self.tableView;
        _viewModel.pool_id = self.pool_id;
        _viewModel.tag_id = self.tag_id;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasMore){
            CA_H_StrongSelf(self)
            
            if (isHasMore) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

            [self.tableView.mj_header endRefreshing];

            [self.tableView reloadData];
        };
    }
    return _viewModel;
}

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [CA_MEmptyView newTitle:@"当前您还没有参与任何项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_project"];
    }
    return _emptyView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = self.emptyView;
        _tableView.backgroundView.hidden = YES;
        CA_H_WeakSelf(self)
        _tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock();
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.loadMoreBlock();
        }];
        _tableView.mj_footer.hidden = YES;
        
        _tableView.contentInset = UIEdgeInsetsMake(8*CA_H_RATIO_WIDTH, 0, 0, 0);
        _tableView.mj_header.ignoredScrollViewContentInsetTop = 8*CA_H_RATIO_WIDTH;
        
        [_tableView registerClass:[CA_MNewProjectNoTagCell class] forCellReuseIdentifier:@"NewProjectNoTagCell"];
        [_tableView registerClass:[CA_MNewProjectTagCell class] forCellReuseIdentifier:@"NewProjectTagCell"];
        [_tableView registerClass:[CA_MNewProjectPlanItemCell class] forCellReuseIdentifier:@"NewProjectPlanItemCell"];
        [_tableView registerClass:[CA_MNewProjectAlreadyItemCell class] forCellReuseIdentifier:@"NewProjectAlreadyItemCell"];
        [_tableView registerClass:[CA_MNewProjectAbandonCell class] forCellReuseIdentifier:@"NewProjectAbandonCell"];
        [_tableView registerClass:[CA_MNewProjectQuitCell class] forCellReuseIdentifier:@"NewProjectQuitCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

@end
