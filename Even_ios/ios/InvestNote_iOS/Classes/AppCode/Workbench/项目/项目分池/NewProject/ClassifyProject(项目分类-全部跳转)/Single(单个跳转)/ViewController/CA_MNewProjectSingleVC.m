//
//  CA_MNewProjectSingleVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectSingleVC.h"
#import "CA_MNewProjectSingleViewManager.h"
#import "CA_MNewProjectSingleViewModel.h"
#import "CA_MNewProjectNoTagCell.h"
#import "CA_MNewProjectTagCell.h"
#import "CA_MNewProjectPlanItemCell.h"
#import "CA_MNewProjectAlreadyItemCell.h"
#import "CA_MNewProjectAbandonCell.h"
#import "CA_MNewProjectQuitCell.h"
#import "CA_HHomeSearchViewController.h"
#import "CA_MNewProjectListModel.h"
#import "CA_MProjectModel.h"
#import "CA_MNewProjectContentVC.h"
#import "CA_MNewSelectProjectVC.h"
#import "CA_MNewSelectProjectViewModel.h"
#import "CA_MNewSelectProjectConditionsModel.h"
#import "CA_MProjectSelectResultView.h"
#import "CA_MEmptyView.h"

@interface CA_MNewProjectSingleVC ()
<
UITableViewDataSource,
UITableViewDelegate,
CA_MProjectSelectResultViewDelegate
>

@property (nonatomic,strong) CA_MNewProjectSingleViewManager *viewManager;

@property (nonatomic,strong) CA_MNewProjectSingleViewModel *viewModel;

@property (nonatomic,strong) CA_MNewSelectProjectViewModel *selectModel;

@property (nonatomic,strong) NSMutableDictionary *selectedDic;

@property (nonatomic,strong) CA_MProjectSelectResultView *resultView;

@end

@implementation CA_MNewProjectSingleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillDisappear:animated];
}

-(void)upView{
    
    self.navigationItem.title = self.viewModel.title;
    
    self.navigationItem.rightBarButtonItems = self.viewManager.rightBarButtonItems;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.view addSubview:self.resultView];
    self.resultView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 3)
    .widthIs(CA_H_SCREEN_WIDTH)
    .heightIs(25*2*CA_H_RATIO_WIDTH-3);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.viewModel.isFinished ) {
        [self.viewModel listModel];
        return 0;
    }
    
    self.viewManager.tableView.backgroundView.hidden = [NSObject isValueableObject:self.viewModel.listModel.data_list];
    self.viewManager.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.listModel.data_list];
    return self.viewModel.listModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.pool_id.intValue == 15 ||//关注项目
//        self.pool_id.intValue == 0) {//全部项目
//
//    }
    
    CA_MNewProjectTagCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"NewProjectTagCell"];
    tagCell.model = self.viewModel.listModel.data_list[indexPath.row];
    [tagCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return tagCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CA_H_WeakSelf(self)
    CA_MNewProjectContentVC* projectDetailVC = [[CA_MNewProjectContentVC alloc] init];
    CA_MProjectModel *model = self.viewModel.listModel.data_list[indexPath.row];
    projectDetailVC.pId = model.project_id;
    projectDetailVC.refreshBlock = ^(NSNumber *ids){
        CA_H_StrongSelf(self)
        self.viewModel.refreshBlock();
        [CA_H_NotificationCenter postNotificationName:CA_M_RefreshProjectListNotification object:nil];
    };
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.listModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MNewProjectTagCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
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

#pragma mark - CA_MProjectSelectResultViewDelegate

-(void)cancelClick{
    
    self.resultView.hidden = YES;
    
    [self resetLayout:YES];
    
    if (self.selectModel) self.selectModel = nil;
    [self.selectedDic removeAllObjects];
    
    [self.viewManager.emptyView updateTitle:@"当前您还没有参与任何项目"
                         buttonTitle:@""
                           imageName:@"empty_project"];
    
    //清空筛选条件
    self.viewModel.netModel.pool_id = @[self.pool_id];
    [self.viewModel.netModel.user_ids removeAllObjects];
    [self.viewModel.netModel.category_ids removeAllObjects];
    [self.viewModel.netModel.invest_stage_ids removeAllObjects];
    [self.viewModel.netModel.progress_status_ids removeAllObjects];
    
    //
    self.viewModel.filtrating = YES;
    self.viewModel.refreshBlock();
}

#pragma mark - getter and setter

-(void)resetLayout:(BOOL)isRecover{
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake((isRecover?0:25*2*CA_H_RATIO_WIDTH+3), 0, 0, 0));
}

-(NSMutableDictionary *)selectedDic{
    if (!_selectedDic) {
        _selectedDic = @{}.mutableCopy;
    }
    return _selectedDic;
}

-(CA_MProjectSelectResultView *)resultView{
    if (!_resultView) {
        _resultView = [CA_MProjectSelectResultView new];
        _resultView.delegate = self;
        _resultView.hidden = YES;
    }
    return _resultView;
}

-(CA_MNewProjectSingleViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewProjectSingleViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock();
        }];
        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.loadMoreBlock();
        }];
        _viewManager.searchBlock = ^{
            CA_H_StrongSelf(self)
            CA_HHomeSearchViewController* searchVC = [[CA_HHomeSearchViewController alloc] init];
            searchVC.buttonTitle = @"项目";
            [self.navigationController pushViewController:searchVC animated:YES];
        };
        _viewManager.selectBlock = ^{
            CA_H_StrongSelf(self)

            CGRect rect = CGRectMake(0, 64 + CA_H_MANAGER.xheight, CA_H_SCREEN_WIDTH, 240*2*CA_H_RATIO_WIDTH);
            CA_MNewSelectProjectVC *newSelectVC = [[CA_MNewSelectProjectVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id obj) {
                CA_H_StrongSelf(self)
                
                UIBarButtonItem *selectBar = (UIBarButtonItem *)[self.viewManager.rightBarButtonItems firstObject];
                UIButton *selectBtn = (UIButton *)selectBar.customView;
                selectBtn.selected = !selectBtn.isSelected;

                if (!obj) {
                    return ;
                }

                self.selectModel = (CA_MNewSelectProjectViewModel *)obj;
                
                //筛选条件
                
                self.resultView.hidden = NO;
                
                NSMutableString* titleStr = [[NSMutableString alloc] initWithString:@"筛选: "];
                
                for (CA_MNewSelectProjectConditionsModel *model in self.selectModel.dataSource) {
                    for (CA_MNewSelectProjectConditionsDataListModel *m in model.data_list) {
                        if (m.isSelected) {
                            if (m.ids.intValue != 0) {
                                [titleStr appendString:m.name];
                                [titleStr appendString:@"-"];
                            }
                        }
                    }
                }
                
                self.resultView.title = [titleStr substringWithRange:NSMakeRange(0, titleStr.length - 1)];
                
                [self.viewManager.emptyView updateTitle:@"当前您还没有参与任何项目"
                                            buttonTitle:@""
                                              imageName:@"empty_search"];
                
                //
                [self resetLayout:NO];
                

                //清空筛选条件
                [self.viewModel.netModel.user_ids removeAllObjects];
                [self.viewModel.netModel.category_ids removeAllObjects];
                [self.viewModel.netModel.invest_stage_ids removeAllObjects];
                [self.viewModel.netModel.progress_status_ids removeAllObjects];

                for (CA_MNewSelectProjectConditionsModel *model in self.selectModel.dataSource) {

                    CA_MNewSelectProjectConditionsModel *tempModel = [CA_MNewSelectProjectConditionsModel new];
                    tempModel.name = model.name;
                    tempModel.field = model.field;
                    tempModel.data_list = @[].mutableCopy;
                    tempModel.selectedCount = model.selectedCount;
                    tempModel.selected = model.selected;

                    for (CA_MNewSelectProjectConditionsDataListModel *m in model.data_list) {

                        if ([model.field isEqualToString:@"user_ids"]) {//人员
                            if (m.isSelected) {
                                [self.viewModel.netModel.user_ids addObject:m.ids];
                                [tempModel.data_list addObject:m];
                            }
                        }else if ([model.field isEqualToString:@"category_ids"]) {//行业领域
                            if (m.isSelected) {
                                [self.viewModel.netModel.category_ids addObject:m.ids];
                                [tempModel.data_list addObject:m];
                            }
                        }else if ([model.field isEqualToString:@"invest_stage_ids"]) {//轮次
                            if (m.isSelected) {
                                [self.viewModel.netModel.invest_stage_ids addObject:m.ids];
                                [tempModel.data_list addObject:m];
                            }
                        }else if ([model.field isEqualToString:@"progress_status_ids"]) {//进展状态
                            if (m.isSelected) {
                                [self.viewModel.netModel.progress_status_ids addObject:m.ids];
                                [tempModel.data_list addObject:m];
                            }
                        }else if ([model.field isEqualToString:@"pool_id"]) {//新的进展状态
                            if (m.isSelected) {
                                if (self.pool_id.intValue == 15 ) {//关注项目
                                    self.viewModel.netModel.pool_id = @[self.pool_id,m.ids];
                                }else {
                                    self.viewModel.netModel.pool_id = @[m.ids];
                                }
                                
                                [tempModel.data_list addObject:m];
                            }
                        }
                    }
                    [self.selectedDic setObject:tempModel forKey:tempModel.field];
                }

                for (NSNumber *ids in self.viewModel.netModel.user_ids) {
                    if (ids.intValue == 0) {
                        [self.viewModel.netModel.user_ids removeObject:ids];
                    }
                }

                for (NSNumber *ids in self.viewModel.netModel.category_ids) {
                    if (ids.intValue == 0) {
                        [self.viewModel.netModel.category_ids removeObject:ids];
                    }
                }

                for (NSNumber *ids in self.viewModel.netModel.invest_stage_ids) {
                    if (ids.intValue == 0) {
                        [self.viewModel.netModel.invest_stage_ids removeObject:ids];
                    }
                }

                for (NSNumber *ids in self.viewModel.netModel.progress_status_ids) {
                    if (ids.intValue == 0) {
                        [self.viewModel.netModel.progress_status_ids removeObject:ids];
                    }
                }

                //
                self.viewModel.filtrating = YES;
                self.viewModel.refreshBlock();
                
            }];
            
            newSelectVC.finished = ^{
                CA_H_StrongSelf(self)
                
                UIBarButtonItem *selectBar = (UIBarButtonItem *)[self.viewManager.rightBarButtonItems firstObject];
                UIButton *selectBtn = (UIButton *)selectBar.customView;
                selectBtn.selected = !selectBtn.isSelected;

                [self cancelClick];
                
            };
            
            newSelectVC.pool_id = self.pool_id;

            if (self.selectModel) {

                if ([NSObject isValueableObject:self.selectedDic]) {

                    for (CA_MNewSelectProjectConditionsModel *model in self.selectModel.dataSource) {

                        CA_MNewSelectProjectConditionsModel *selModel = self.selectedDic[model.field];

                        if (selModel) {

                            model.name = selModel.name;
                            model.field = selModel.field;
                            model.selectedCount = selModel.selectedCount;
                            model.selected = selModel.isSelected;
                            if (model.isSelected) {
                                self.selectModel.field = model.field;
                            }

                            for (CA_MNewSelectProjectConditionsDataListModel *listModel in model.data_list) {

                                for (CA_MNewSelectProjectConditionsDataListModel *obj in selModel.data_list) {

                                    if (listModel.ids == obj.ids) {
                                        listModel.selected = YES;
                                        break;
                                    }else{
                                        listModel.selected = NO;
                                    }
                                }

                            }

                        }
                    }

                }

                newSelectVC.viewModel = self.selectModel;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:newSelectVC animated:YES completion:nil];
            });
            
            
        };
    }
    return _viewManager;
}

-(CA_MNewProjectSingleViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewProjectSingleViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.pool_id = self.pool_id;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasMore){
            CA_H_StrongSelf(self)
            
            if (isHasMore) {
                [self.viewManager.tableView.mj_footer endRefreshing];
            }else {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.viewManager.tableView.mj_header endRefreshing];
            
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}


@end
