//
//  CA_MNewProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectVC.h"
#import "CA_MNewProjectViewManager.h"
#import "CA_MNewProjectViewModel.h"
#import "CA_MSearchProjectVC.h"
#import "CA_MSettingPanelVC.h"
#import "CA_MSelectItemVC.h"
#import "CA_MSettingType.h"
#import "CA_MChangeWorkSpace.h"
#import "CA_MNewPersonVC.h"
#import "CA_MProjectSearchView.h"
#import "CA_HHomeSearchViewController.h"
#import "CA_MNewProjectSearchView.h"
#import "CA_MNewProjectSectionView.h"
#import "CA_MNewProjectFooterView.h"
#import "CA_MNewProjectAllTypeCell.h"
#import "CA_MNewProjectAttentionCell.h"
#import "CA_MNewProjectStoreCell.h"
#import "CA_MNewProjectPlanCell.h"
#import "CA_MNewProjectAlreadyCell.h"
#import "CA_MNewProjectNoItemCell.h"
#import "CA_MNewProjectSingleVC.h"
#import "CA_MNewProjectMultiVC.h"
#import "CA_MNewProjectModel.h"
#import "CA_MNewProjectContentVC.h"

@interface CA_MNewProjectVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic,strong) CA_MNewProjectViewManager *viewManager;
@property (nonatomic,strong) CA_MNewProjectViewModel *viewModel;
@end

@implementation CA_MNewProjectVC

-(void)dealloc{
    [CA_H_NotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    
    [self addNotificationss];
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
    
    self.navigationItem.titleView = self.viewManager.titleViewBtn;
    self.navigationItem.leftBarButtonItem = self.viewManager.leftBarBtn;
    self.navigationItem.rightBarButtonItem = self.viewManager.rightBarBtn;
    
    [self.view addSubview:self.viewManager.collectionView];
    self.viewManager.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 10*2*CA_H_RATIO_WIDTH, 0, 10*2*CA_H_RATIO_WIDTH));
}

-(void)addNotificationss{
    [CA_H_NotificationCenter addObserver:self
                                selector:@selector(refreshWorkbench)
                                    name:CA_M_RefreshProjectListNotification
                                  object:nil];
    
    [CA_H_NotificationCenter addObserver:self
                                selector:@selector(refreshWorkbench)
                                    name:CA_M_RefreshWorkbenchNotification
                                  object:nil];
}

-(void)refreshWorkbench{
    self.viewModel.refreshBlock();
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (!self.viewModel.isFinished ) {
        [self.viewModel model];
       return 0;
    }
    
    int sections = 0;
    if ([NSObject isValueableObject:self.viewModel.model.split_pool_count]) {
        sections = 1;
    }
    sections += self.viewModel.model.split_pool_list.count;
    collectionView.backgroundView.hidden = sections;
    return sections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.viewModel.model.split_pool_count.count;
    }
    return [[self.viewModel.model.split_pool_list[section-1] valueForKey:@"pool_list"] count] == 0?1:[[self.viewModel.model.split_pool_list[section-1] valueForKey:@"pool_list"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        CA_MNewProjectSplitPoolListModel *model = self.viewModel.model.split_pool_list[indexPath.section-1];
        
        if (![NSObject isValueableObject:model.pool_list]) {
            CA_MNewProjectNoItemCell *noItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectNoItemCell" forIndexPath:indexPath];
            return noItemCell;
        }
        
        if (model.pool_id.intValue == 15 ||//关注项目
            model.pool_id.intValue == 13 ||//放弃项目
            model.pool_id.intValue == 10) {//退出项目
            CA_MNewProjectAttentionCell *attentionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectAttentionCell" forIndexPath:indexPath];
            attentionCell.model = model.pool_list[indexPath.item];
            return attentionCell;
        }else if (model.pool_id.intValue == 1) {//储备项目
            CA_MNewProjectStoreCell *storeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectStoreCell" forIndexPath:indexPath];
            storeCell.model = model.pool_list[indexPath.item];
            return storeCell;
        }else if (model.pool_id.intValue == 5) {//拟投项目
            CA_MNewProjectPlanCell *planCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectPlanCell" forIndexPath:indexPath];
            planCell.model = model.pool_list[indexPath.item];
            return planCell;
        }else if (model.pool_id.intValue == 8) {//已投项目
            CA_MNewProjectAlreadyCell *readyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectAlreadyCell" forIndexPath:indexPath];
            readyCell.model = model.pool_list[indexPath.item];
            return readyCell;
        }
    }
    
    //全部类型
    CA_MNewProjectAllTypeCell *allTypeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectAllTypeCell" forIndexPath:indexPath];
    allTypeCell.model = self.viewModel.model.split_pool_count[indexPath.item];
    return allTypeCell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CA_MNewProjectSplitPoolModel *poolModel = self.viewModel.model.split_pool_count[indexPath.item];
        if (poolModel.pool_id.intValue == 15 ||//关注项目
            poolModel.pool_id.intValue == 0 ) {//全部项目
            CA_MNewProjectSingleVC *singleVC = [[CA_MNewProjectSingleVC alloc] init];
            singleVC.pool_id = poolModel.pool_id;
            [self.navigationController pushViewController:singleVC animated:YES];
        }else {//其他类型项目
            CA_MNewProjectMultiVC *multiVC = [[CA_MNewProjectMultiVC alloc] init];
            multiVC.pool_id = poolModel.pool_id;
            [self.navigationController pushViewController:multiVC animated:YES];
        }
    }else {
        CA_H_WeakSelf(self)
        __weak CA_MNewProjectSplitPoolListModel *poolListMode = self.viewModel.model.split_pool_list[indexPath.section-1];
        if ([NSObject isValueableObject:poolListMode.pool_list]) {
            CA_MProjectModel *model = poolListMode.pool_list[indexPath.item];
            CA_MNewProjectContentVC* projectDetailVC = [[CA_MNewProjectContentVC alloc] init];
            projectDetailVC.pId = model.project_id;
            projectDetailVC.refreshBlock = ^(NSNumber *ids){
                CA_H_StrongSelf(self)
                [poolListMode.pool_list enumerateObjectsUsingBlock:^(CA_MProjectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //                if (obj.project_id == ids) {
                    //                    [poolListMode.pool_list removeObject:obj];
                    //                    [self.viewManager.collectionView reloadData];
                    //                    *stop = YES;
                    //                }
                    self.viewModel.refreshBlock();
                }];
            };
            [self.navigationController pushViewController:projectDetailVC animated:YES];
        }
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        
        CA_MNewProjectSplitPoolListModel *model = self.viewModel.model.split_pool_list[indexPath.section-1];
        
        if (![NSObject isValueableObject:model.pool_list]) {
            return CGSizeMake(CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2, 50*2*CA_H_RATIO_WIDTH);
        }
        
        if (model.pool_id.intValue == 15 ||//关注项目
            model.pool_id.intValue == 13 ||//放弃项目
            model.pool_id.intValue == 10) {//退出项目
            return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2-9*2*CA_H_RATIO_WIDTH*3)/4, 50*2*CA_H_RATIO_WIDTH);
        }else if (model.pool_id.intValue == 1) {//储备项目
            return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2), (42+5)*2*CA_H_RATIO_WIDTH);
        }else if (model.pool_id.intValue == 5) {//拟投项目
            return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2-17*2*CA_H_RATIO_WIDTH)/2, 35*2*CA_H_RATIO_WIDTH);
        }else if (model.pool_id.intValue == 8) {//已投项目
            CA_MProjectModel *itemModel = model.pool_list[indexPath.item];
            if (![NSObject isValueableObject:itemModel.risk_tag_list]) {
                return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2), (42+5-10)*2*CA_H_RATIO_WIDTH);
            }
            return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2), (42+5)*2*CA_H_RATIO_WIDTH);
        }
    }
    //全部分类
    return CGSizeMake((CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2-5*2*CA_H_RATIO_WIDTH*3)/4, (38+5)*2*CA_H_RATIO_WIDTH);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CA_H_WeakSelf(self)
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section != 0) {
            CA_MNewProjectSplitPoolListModel *model = self.viewModel.model.split_pool_list[indexPath.section-1];
            CA_MNewProjectSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProjectSectionView" forIndexPath:indexPath];
            sectionView.model = model;
            sectionView.lookMoreBlock = ^{
                CA_H_StrongSelf(self)
                if (model.pool_id.intValue == 15 ||//关注项目
                    model.pool_id.intValue == 0 ) {//全部项目
                    CA_MNewProjectSingleVC *singleVC = [[CA_MNewProjectSingleVC alloc] init];
                    singleVC.pool_id = model.pool_id;
                    [self.navigationController pushViewController:singleVC animated:YES];
                }else {//其他类型项目
                    CA_MNewProjectMultiVC *multiVC = [[CA_MNewProjectMultiVC alloc] init];
                    multiVC.pool_id = model.pool_id;
                    [self.navigationController pushViewController:multiVC animated:YES];
                } 
            };
            return sectionView;
        }
        
        CA_MNewProjectSearchView *searchView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProjectSearchView" forIndexPath:indexPath];
        searchView.jumpBlock = ^{
            CA_H_StrongSelf(self)
            CA_HHomeSearchViewController* searchVC = [[CA_HHomeSearchViewController alloc] init];
            searchVC.buttonTitle = @"项目";
            [self.navigationController pushViewController:searchVC animated:YES];
        };
        return searchView;
    }
    
    CA_MNewProjectFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewProjectFooterView" forIndexPath:indexPath];
    return footerView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 0?CGSizeMake(CA_H_SCREEN_WIDTH, 55*CA_H_RATIO_WIDTH):CGSizeMake(CA_H_SCREEN_WIDTH, (13+10)*2*CA_H_RATIO_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return (section == (collectionView.numberOfSections-1))?CGSizeMake(CA_H_SCREEN_WIDTH, 40*2*CA_H_RATIO_WIDTH):CGSizeZero;
}

#pragma mark - getter and setter

-(CA_MNewProjectViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewProjectViewManager new];
        _viewManager.collectionView.dataSource = self;
        _viewManager.collectionView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.collectionView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.refreshBlock();
        }];
        _viewManager.leftBlock = ^{
            CA_H_StrongSelf(self)
            CA_MSettingPanelVC *settingPanelVC = [CA_MSettingPanelVC new];
            settingPanelVC.editBlock = ^{
                CA_H_StrongSelf(self)
                self.viewModel.refreshBlock();
            };
            [self.navigationController pushViewController:settingPanelVC animated:YES];
        };
        _viewManager.rightBlock = ^{
            CA_H_StrongSelf(self)
            CA_MSearchProjectVC *addProjectVC = [CA_MSearchProjectVC new];
            [self.navigationController pushViewController:addProjectVC animated:YES];
        };
        _viewManager.titleBlock = ^(UIButton *sender) {
            CA_H_StrongSelf(self)
            CA_MSelectItemVC *selectItemVC = [[CA_MSelectItemVC alloc] initWithShowFrame:CGRectMake(0,Navigation_Height, CA_H_SCREEN_WIDTH, 150*CA_H_RATIO_WIDTH) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id callback) {
                CA_H_StrongSelf(self);
                self.viewManager.titleViewBtn.selected = !self.viewManager.titleViewBtn.isSelected;
            }];
            selectItemVC.currentItemKey = SettingType_Project;
            selectItemVC.block = ^(NSString *itemKey, NSString *item) {
                CA_H_StrongSelf(self)
                if ([itemKey isEqualToString:SettingType_Project]) return ;
                [CA_MChangeWorkSpace replaceWorkSpace:[CA_MNewPersonVC new]];
            };
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:selectItemVC animated:YES completion:nil];
            });
        };
        
    }
    return _viewManager;
}

-(CA_MNewProjectViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewProjectViewModel new];
        _viewModel.loadingView = self.viewManager.collectionView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            [self.viewManager.collectionView.mj_header endRefreshing];
            [self.viewManager.collectionView reloadData];
        };
    }
    return _viewModel;
}

@end



