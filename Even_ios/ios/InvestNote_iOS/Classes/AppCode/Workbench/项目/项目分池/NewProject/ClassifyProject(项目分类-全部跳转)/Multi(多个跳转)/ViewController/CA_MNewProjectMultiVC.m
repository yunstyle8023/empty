//
//  CA_MNewProjectMultiVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectMultiVC.h"
#import "CA_MNewProjectSingleViewManager.h"
#import "CA_HHomeSearchViewController.h"
#import "CA_MNewProjectSingleViewModel.h"
#import "CA_MNewSelectProjectVC.h"
#import "CA_MNewProjectMultiView.h"
#import "CA_MSelectProjectNetModel.h"
#import "CA_MSelectProjectNetModel.h"
#import "CA_MNewSelectProjectConditionsModel.h"
#import "CA_MNewSelectProjectViewModel.h"
#import "CA_MProjectModel.h"
#import "CA_MProjectSelectResultView.h"
#import "CA_MEmptyView.h"
#import "CA_MNewProjectListModel.h"

@interface CA_MNewProjectMultiVC ()
<
CA_MProjectSelectResultViewDelegate
>

@property (nonatomic,strong) CA_MNewProjectSingleViewManager *viewManager;

@property (nonatomic,strong) CA_MNewProjectSingleViewModel *viewModel;

@property (nonatomic,assign,getter=isFirstRequest) BOOL firstRequest;

@property (nonatomic,strong) CA_MNewSelectProjectViewModel *selectModel;

@property (nonatomic,strong) NSMutableDictionary *selectedDic;

@property (nonatomic,strong) CA_MProjectSelectResultView *resultView;

@property (nonatomic,strong) CA_MEmptyView *emptyView;

@end

@implementation CA_MNewProjectMultiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstRequest = YES;
    [self upView];
    [self.viewModel listModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

-(void)upView{
    self.navigationItem.title = self.viewModel.title;
    self.navigationItem.rightBarButtonItems = self.viewManager.rightBarButtonItems;
}

- (void)ca_layoutContentView {
    [super ca_layoutContentView];
    [self customScrollView];
}

-(CGRect)buttonViewFrame{
    if ([self.viewModel.listModel.project_tag_list count] <= 1) {
        CGRect rect = [super buttonViewFrame];
        rect.size.height = 0;
        return rect;
    }
    return [super buttonViewFrame];
}

- (NSArray *)scrollViewTitles {
    return self.viewModel.tagNames;
}

- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    return self.viewModel.tagViews[item];
}

#pragma mark - CA_MProjectSelectResultViewDelegate

-(void)cancelClick{
    self.resultView.hidden = YES;
    
    if (self.selectModel) self.selectModel = nil;
    [self.selectedDic removeAllObjects];
    
    for (CA_MNewProjectMultiView *multiView in self.viewModel.tagViews) {
        
        [multiView.emptyView updateTitle:@"当前您还没有参与任何项目"
                             buttonTitle:@""
                               imageName:@"empty_project"];
        
        [multiView resetLayout:YES];
        
        //清空筛选条件
        multiView.viewModel.netModel.pool_id = @[self.pool_id];
        [multiView.viewModel.netModel.user_ids removeAllObjects];
        [multiView.viewModel.netModel.category_ids removeAllObjects];
        [multiView.viewModel.netModel.invest_stage_ids removeAllObjects];
        [multiView.viewModel.netModel.progress_status_ids removeAllObjects];
        
        //
        multiView.viewModel.filtrating = YES;
        multiView.viewModel.refreshBlock();
    }
    
}

#pragma mark - getter and setter

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

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [CA_MEmptyView newTitle:@"当前您还没有参与任何项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_project"];
    }
    return _emptyView;
}

-(CA_MNewProjectSingleViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewProjectSingleViewManager new];
        CA_H_WeakSelf(self)
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
                
                //
                
                for (CA_MNewProjectMultiView *multiView in self.viewModel.tagViews) {
                    
                    [multiView.emptyView updateTitle:@"当前您还没有参与任何项目"
                                         buttonTitle:@""
                                           imageName:@"empty_search"];
                    
                    [multiView resetLayout:NO];
                    
                    //清空筛选条件
                    [multiView.viewModel.netModel.user_ids removeAllObjects];
                    [multiView.viewModel.netModel.category_ids removeAllObjects];
                    [multiView.viewModel.netModel.invest_stage_ids removeAllObjects];
                    [multiView.viewModel.netModel.progress_status_ids removeAllObjects];
                    
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
                                    [multiView.viewModel.netModel.user_ids addObject:m.ids];
                                    [tempModel.data_list addObject:m];
                                }
                            }else if ([model.field isEqualToString:@"category_ids"]) {//行业领域
                                if (m.isSelected) {
                                    [multiView.viewModel.netModel.category_ids addObject:m.ids];
                                    [tempModel.data_list addObject:m];
                                }
                            }else if ([model.field isEqualToString:@"invest_stage_ids"]) {//轮次
                                if (m.isSelected) {
                                    [multiView.viewModel.netModel.invest_stage_ids addObject:m.ids];
                                    [tempModel.data_list addObject:m];
                                }
                            }else if ([model.field isEqualToString:@"progress_status_ids"]) {//进展状态
                                if (m.isSelected) {
                                    [multiView.viewModel.netModel.progress_status_ids addObject:m.ids];
                                    [tempModel.data_list addObject:m];
                                }
                            }else if ([model.field isEqualToString:@"pool_id"]) {//新的进展状态
                                if (m.isSelected) {
                                    multiView.viewModel.netModel.pool_id = @[m.ids];
                                    [tempModel.data_list addObject:m];
                                }
                            }
                        }
                        [self.selectedDic setObject:tempModel forKey:tempModel.field];
                    }
                    
                    for (NSNumber *ids in multiView.viewModel.netModel.user_ids) {
                        if (ids.intValue == 0) {
                            [multiView.viewModel.netModel.user_ids removeObject:ids];
                        }
                    }
                    
                    for (NSNumber *ids in multiView.viewModel.netModel.category_ids) {
                        if (ids.intValue == 0) {
                            [multiView.viewModel.netModel.category_ids removeObject:ids];
                        }
                    }
                    
                    for (NSNumber *ids in multiView.viewModel.netModel.invest_stage_ids) {
                        if (ids.intValue == 0) {
                            [multiView.viewModel.netModel.invest_stage_ids removeObject:ids];
                        }
                    }
                    
                    for (NSNumber *ids in multiView.viewModel.netModel.progress_status_ids) {
                        if (ids.intValue == 0) {
                            [multiView.viewModel.netModel.progress_status_ids removeObject:ids];
                        }
                    }
                    
                    //
                    multiView.viewModel.filtrating = YES;
                    multiView.viewModel.refreshBlock();
                }
                
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
        _viewModel.loadingView = CA_H_MANAGER.mainWindow;
        _viewModel.pool_id = self.pool_id;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasMore){
            CA_H_StrongSelf(self)
            
            //只调用一次  频繁的销毁耗费性能
            if (self.isFirstRequest) {
                
                [self cleanScrollView];
                [self customScrollView];
                
                BOOL singleItem = [self.viewModel.listModel.project_tag_list count] <= 1;
                
                self.emptyView.hidden = [NSObject isValueableObject:self.viewModel.listModel.project_tag_list];
                [self.view addSubview:self.emptyView];
                self.emptyView.sd_layout
                .spaceToSuperView(UIEdgeInsetsZero);
                //筛选条件
                [self.view addSubview:self.resultView];
                self.resultView.sd_layout
                .leftEqualToView(self.view)
                .topSpaceToView(self.view, (singleItem?3:18*2*CA_H_RATIO_WIDTH+3))
                .widthIs(CA_H_SCREEN_WIDTH)
                .heightIs(25*2*CA_H_RATIO_WIDTH-3);
                
            }
            self.firstRequest = NO;

        };
    }
    return _viewModel;
}

@end














