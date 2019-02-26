//
//  CA_HBusinessDetailsController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessDetailsController.h"

#import "CA_HBusinessDetailsViewManager.h"

#import "CA_HDetailBaseCollectionCell.h"

#import "CA_HGeneralSituationController.h"//上市概况
#import "CA_HFinancialDataController.h"//财务数据
#import "CA_HBusinessInformationController.h"//工商信息
#import "CA_HForeignInvestmentController.h"//对外投资
#import "CA_HRiskInformationController.h"//风险信息
#import "CA_HDownloadCenterViewController.h"//下载中心

@interface CA_HBusinessDetailsController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CA_HBusinessDetailsViewManager *viewManager;

@end

@implementation CA_HBusinessDetailsController

#pragma mark --- Action

- (void)onNavBar:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    switch (sender.tag) {
        case 100: //返回
            [self ca_backAction];
            break;
        case 101: //分享
            [self share];
            break;
        case 102: //长图
            [CA_HFoundFactoryPattern generateImage:self.viewManager.image nav:self.navigationController];
            break;
        default:
            break;
    }
    sender.userInteractionEnabled = YES;

}

#pragma mark --- Lazy

- (CA_HBusinessDetailsModelManager *)modelManager {
    if (!_modelManager) {
        CA_HBusinessDetailsModelManager *modelManager = [CA_HBusinessDetailsModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.loadDetailBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            if (success) {
                if (!self.viewManager.collectionView.superview) {
                    [self upView];
                }
            } else {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            }
            
            [CA_HProgressHUD hideHud:self.view animated:YES];
        };
    }
    return _modelManager;
}

- (CA_HBusinessDetailsViewManager *)viewManager {
    if (!_viewManager) {
        CA_HBusinessDetailsViewManager *viewManager = [CA_HBusinessDetailsViewManager new];
        _viewManager = viewManager;
        
        [viewManager customTop:self.modelManager.model.enterprise_name tag:self.modelManager.model.status target:self action:@selector(onNavBar:)];
        
        viewManager.collectionView.delegate = self;
        viewManager.collectionView.dataSource = self;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHidden = YES;
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadDetail];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.collectionView];
    self.viewManager.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(64+CA_H_MANAGER.xheight, 0, 0, 0));
    
    [self.view addSubview:self.viewManager.topView];
    [self.view bringSubviewToFront:self.viewManager.topView];
}

- (void)share {
    [CA_H_MANAGER shareDetail:self data_type:self.modelManager.model.data_type data_id:self.modelManager.model.enterprise_name block:nil];
}

#pragma mark --- StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark --- Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y+self.viewManager.height;
    if (offsetY <= 0) { // 开始状态
        self.viewManager.titleLabel.textAlignment= NSTextAlignmentLeft;
        self.viewManager.titleLabel.font = CA_H_FONT_PFSC_Regular(22);
        self.viewManager.tagLabel.alpha = 1;
        self.viewManager.topView.height = self.viewManager.height+64+CA_H_MANAGER.xheight;
        self.viewManager.titleLabel.frame = self.viewManager.frame;
        if (!self.viewManager.headerImage) {
            self.viewManager.headerImage = [self.viewManager.topView snapshotImage];
        }
    } else if (offsetY >= self.viewManager.height)  { // 结束状态
        self.viewManager.titleLabel.textAlignment= NSTextAlignmentCenter;
        self.viewManager.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.viewManager.tagLabel.alpha = 0;
        self.viewManager.topView.height = 64+CA_H_MANAGER.xheight;
        self.viewManager.titleLabel.height = 30*CA_H_RATIO_WIDTH;
        self.viewManager.titleLabel.width = MIN(209*CA_H_RATIO_WIDTH, self.viewManager.frame.size.width);
        self.viewManager.titleLabel.center = CGPointMake(162.5*CA_H_RATIO_WIDTH, 42+CA_H_MANAGER.xheight);
    } else {// 中间变化
        self.viewManager.tagLabel.alpha = 1 - offsetY/(self.viewManager.height-38*CA_H_RATIO_WIDTH);
        self.viewManager.topView.height = self.viewManager.height+64+CA_H_MANAGER.xheight - offsetY;
        
        {
            
            CGRect frame = self.viewManager.frame;
            CGFloat lineHeight = self.viewManager.titleLabel.font.lineHeight;
            CGFloat labelHeight = frame.size.height - lineHeight*ceilf((offsetY-5*CA_H_RATIO_WIDTH)/lineHeight);
            
            if (labelHeight <= 30*CA_H_RATIO_WIDTH) { // label 二段变化
                CGFloat height = self.viewManager.height - offsetY;
                CGFloat change = 1-height/(self.viewManager.height-frame.size.height+30*CA_H_RATIO_WIDTH);
                frame.size.height = 30*CA_H_RATIO_WIDTH;
                
                self.viewManager.titleLabel.textAlignment= NSTextAlignmentCenter;
                
                CGFloat font = 22*CA_H_RATIO_WIDTH+(17-22*CA_H_RATIO_WIDTH)*change;
                self.viewManager.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:font];
                
                self.viewManager.titleLabel.height = 30*CA_H_RATIO_WIDTH;
                if (frame.size.width > 209*CA_H_RATIO_WIDTH) {
                    self.viewManager.titleLabel.width = frame.size.width+(209*CA_H_RATIO_WIDTH-frame.size.width)*change;
                }
                
                CGPoint point0 = CGRectGetCenter(frame);
                CGPoint point1 = CGPointMake(162.5*CA_H_RATIO_WIDTH, 42+CA_H_MANAGER.xheight);
                self.viewManager.titleLabel.center = CGPointMake(point0.x+(point1.x-point0.x)*change, point0.y+(point1.y-point0.y)*change);
                
            } else if (labelHeight > frame.size.height) { // label固定
                self.viewManager.titleLabel.font = CA_H_FONT_PFSC_Regular(22);
                self.viewManager.titleLabel.textAlignment= NSTextAlignmentLeft;
                self.viewManager.titleLabel.frame = frame;
            } else { // label 一段变化
                self.viewManager.titleLabel.font = CA_H_FONT_PFSC_Regular(22);
                self.viewManager.titleLabel.textAlignment= NSTextAlignmentLeft;
                frame.size.height = labelHeight;
                self.viewManager.titleLabel.frame = frame;
            }
        }
    }
}

#pragma mark --- Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CA_HEnterpriseBusinessInfoModel *model = self.modelManager.model;
    switch (section) {
        case 0:
            if (model.is_on_stock.integerValue==1) {
                return 1+model.stock_modules_list.count;
            } else {
                return 0;
            }
        case 1:
            return model.basic_modules_list.count;
        case 2:
            return model.risk_modules_list.count;
        case 3:
            return 1;
        default:
            return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return CGSizeMake(335*CA_H_RATIO_WIDTH, 225*CA_H_RATIO_WIDTH);
    } else if (indexPath.section == 0 && indexPath.item == 0) {
        if (self.modelManager.model.is_on_stock.integerValue==1) {
            return CGSizeMake(335*CA_H_RATIO_WIDTH, 93*CA_H_RATIO_WIDTH);
        }
    }
    return CGSizeMake(102*CA_H_RATIO_WIDTH, 102*CA_H_RATIO_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([collectionView numberOfItemsInSection:section]) {
        return CGSizeMake(CA_H_SCREEN_WIDTH, 65*CA_H_RATIO_WIDTH);
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self.viewManager header:indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CA_HEnterpriseBusinessInfoModel *model = self.modelManager.model;
    
    NSString *identifier = @"CA_HInformationModuleCell";
    if (indexPath.section == 3) {
        identifier = @"CA_HApplicationReportCell";
    } else if (indexPath.section == 0 && indexPath.item == 0) {
        if (model.is_on_stock.integerValue==1) {
            identifier = @"CA_HStockMarketCell";
        }
    }
    CA_HDetailBaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if (indexPath.section == 3) {
        cell.model = model.creditreport_data_list;
        CA_H_WeakSelf(self);
        cell.block = ^{
            CA_H_StrongSelf(self);
            [self.navigationController pushViewController:[CA_HDownloadCenterViewController new] animated:YES];
        };
    } else if (indexPath.section == 0
               &&
               indexPath.item == 0
               &&
               model.is_on_stock.integerValue==1) {
        cell.model = model.stock_data_list;
    } else {
        switch (indexPath.section) {
            case 0:
                if (model.is_on_stock.integerValue==1) {
                    cell.model = model.stock_modules_list[indexPath.item-1];
                } else {
                    cell.model = model.stock_modules_list[indexPath.item];
                }
                break;
            case 1:
                cell.model = model.basic_modules_list[indexPath.item];
                break;
            case 2:
                cell.model = model.risk_modules_list[indexPath.item];
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HDetailBaseCollectionCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    CA_HEnterpriseModules *model = cell.model;
    if (![model isKindOfClass:[CA_HEnterpriseModules class]]) {
        return;
    }
    
    UIViewController *vc = nil;
    switch (indexPath.section) {
        case 0:
        {
            if ([model.data_type isEqualToString:@"listedbasicinfo"]) {
                CA_HGeneralSituationController *generalSituationVC = [CA_HGeneralSituationController new];
                vc = generalSituationVC;
                
                generalSituationVC.modelManager.stockCode = model.stock_code;
            } else if ([model.data_type isEqualToString:@"financialdata"]) {
                CA_HFinancialDataController *financialDataVC = [CA_HFinancialDataController new];
                vc = financialDataVC;
                
                financialDataVC.modelManager.financialDate = model.financial_date;
                financialDataVC.modelManager.stockCode = model.stock_code;
                
                NSInteger item = [@[@"assets_liabilities", @"profits", @"cash_flow"] indexOfObject:model.financial_type.firstObject];
                if (item != NSNotFound) {
                    financialDataVC.modelManager.item = item;
                } else {
                    financialDataVC.modelManager.item = 0;
                }
            }
        }
            break;
        case 1:
        {
            if ([model.data_type isEqualToString:@"enterprise"]) {
                CA_HBusinessInformationController *businessInformationVC = [CA_HBusinessInformationController new];
                vc = businessInformationVC;
                
                businessInformationVC.modelManager.dataStr = self.modelManager.model.enterprise_name;
            } else if ([model.data_type isEqualToString:@"investevent"]) {
                CA_HForeignInvestmentController *investVC = [CA_HForeignInvestmentController new];
                vc = investVC;
                
                investVC.modelManager.searchStr = self.modelManager.model.enterprise_name;
            }
        }
            break;
        case 2:
        {
            if (model.nums.integerValue == 0) {
                return;
            }
            CA_HRiskInformationController *riskVC = [CA_HRiskInformationController new];
            vc = riskVC;
            
            riskVC.modelManager.keyno = self.modelManager.model.keyno;
            riskVC.modelManager.searchName = self.modelManager.model.enterprise_name;
            riskVC.modelManager.dataType = model.data_type;
        }
            break;
        default:
            break;
    }
    
    if (vc) {
        vc.title = model.module_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
