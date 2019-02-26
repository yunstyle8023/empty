//
//  CA_HRiskInformationController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskInformationController.h"

#import "CA_HRiskInformationViewManager.h"

#import "CA_HRiskInformationCollectionCell.h"

#import "CA_HShowWebViewController.h"

@interface CA_HRiskInformationController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CA_HRiskInformationViewManager *viewManager;

@end

@implementation CA_HRiskInformationController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HRiskInformationModelManager *)modelManager {
    if (!_modelManager) {
        CA_HRiskInformationModelManager *modelManager = [CA_HRiskInformationModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.finishBlock = ^(BOOL noMore) {
            CA_H_StrongSelf(self);
            CA_H_WeakSelf(self);
            
//            CA_H_DISPATCH_MAIN_THREAD(^{
//                [self.viewManager.collectionView reloadData];
//                if (@available(iOS 11.0, *)) {
//                    
//                } else {
//                    [self.viewManager.collectionView.collectionViewLayout invalidateLayout];
//                }
//            })
            
            [self.viewManager.collectionView reloadData];
            if (@available(iOS 11.0, *)) {
                
            } else {
                [self.viewManager.collectionView.collectionViewLayout invalidateLayout];
            }
            
            [self.viewManager.collectionView.mj_header endRefreshing];
            if (noMore) {
                [self.viewManager.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.viewManager.collectionView.mj_footer endRefreshing];
            }
            
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _modelManager;
}

- (CA_HRiskInformationViewManager *)viewManager {
    if (!_viewManager) {
        CA_HRiskInformationViewManager *viewManager = [CA_HRiskInformationViewManager new];
        _viewManager = viewManager;
        
        CA_H_WeakSelf(self);
        viewManager.collectionView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore:@(1)];
        }];
        
        viewManager.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore:@(self.modelManager.model.page_num.integerValue+1)];
        }];
        
//        viewManager.collectionView.mj_header.ignoredScrollViewContentInsetTop = 20*CA_H_RATIO_WIDTH;
//        viewManager.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = 20*CA_H_RATIO_WIDTH;
        
        viewManager.collectionView.delegate = self;
        viewManager.collectionView.dataSource = self;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadMore:@(1)];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.collectionView];
    self.viewManager.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Collection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelManager.data.count;
}

- (CA_HRiskInformationCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HRiskInformationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.dataType = self.modelManager.dataType;
    cell.model = self.modelManager.data[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.modelManager.dataType isEqualToString:@"runexception"]) {
        
    } else if ([self.modelManager.dataType isEqualToString:@"judgementdoclist"]) {
        CA_HShowWebViewController *vc = [CA_HShowWebViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
        [CA_HProgressHUD loading:vc.view];
        NSDictionary *parameters =
        @{@"id_num": [self.modelManager.data[indexPath.item] id_num]?:@""};
        CA_H_WeakSelf(self);
        [CA_HNetManager postUrlStr:CA_H_Api_JudgementDocDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0
                    &&
                    [netModel.data isKindOfClass:[NSDictionary class]]) {
                    [vc.webView loadHTMLString:[NSString stringWithFormat:@"<div style='padding: %@px'>%@</div>", @(20*CA_H_RATIO_WIDTH), netModel.data[@"content"]] baseURL:nil];
                    return;
                }
            }
            
            [CA_HProgressHUD hideHud:vc.view];
            if (netModel.error.code != -999) {
                if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        } progress:nil];
        
        
        
        
    } else {
        CA_HRiskInformationCollectionCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.model setIsShow:![cell.model isShow]];

        CGPoint offset = collectionView.contentOffset;
        [collectionView reloadData];
        [collectionView layoutIfNeeded];
        [collectionView setContentOffset:offset];
        [collectionView layoutSubviews];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }
}

@end
