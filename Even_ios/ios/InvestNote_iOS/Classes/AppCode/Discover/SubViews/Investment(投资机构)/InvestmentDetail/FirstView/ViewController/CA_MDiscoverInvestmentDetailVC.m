//
//  CA_MDiscoverInvestmentDetailVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentDetailVC.h"
#import "CA_MDiscoverInvestmentDetailViewManager.h"
#import "CA_MDiscoverInvestmentDetailViewModel.h"
#import "CA_MDiscoverInvestmentDetailHeaderView.h"
#import "CA_MDiscoverInvestmentDetailModel.h"
#import "CA_MDiscoverSponsorDetailItemCell.h"
#import "CA_MDiscoverInvestmentDetailIntroCell.h"
#import "CA_MDiscoverProjectDetailCorePersonCell.h"
#import "CA_MDiscoverProjectDetailSectionHeaderView.h"
#import "CA_MDiscoverProjectDetailSectionFooterView.h"
#import "CA_MDiscoverSponsorDetailModel.h"
#import "CA_MDiscoverInvestmentManageFoundsVC.h"
#import "CA_MDiscoverInvestmentCommerceVC.h"
#import "CA_MDiscoverInvestmentMemberListVC.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentDetailVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverInvestmentDetailViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverInvestmentDetailViewModel *viewModel;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation CA_MDiscoverInvestmentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
    [self setConstrains];
}

-(void)upView{
    self.navBarHidden = YES;
    
    [self.view addSubview:self.viewManager.naviView];
    [self.view addSubview:self.viewManager.headerView];
    [self.view addSubview:self.viewManager.tableView];
    [self.view bringSubviewToFront:self.viewManager.headerView];
    [self.view bringSubviewToFront:self.viewManager.naviView];
    
    [self.view addSubview:self.titleLb];
}

-(void)setConstrains{
    self.viewManager.naviView.sd_resetLayout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(64+CA_H_MANAGER.xheight);
    
    self.viewManager.headerView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(self.headerHeight);
    self.viewManager.headerView.mj_y = 64+CA_H_MANAGER.xheight;
    
    self.viewManager.tableView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 64+CA_H_MANAGER.xheight)
    .bottomEqualToView(self.view);

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onNavBar:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    switch (sender.tag) {
        case 100: //返回
            [self ca_backAction];
            break;
        case 101: //分享
            [CA_H_MANAGER shareDetail:self data_type:@"gp" data_id:self.data_id block:nil];
            break;
        case 102: //长图
            [CA_HFoundFactoryPattern generateImage:self.viewManager.image nav:self.navigationController];
            break;
        default:
            break;
    }
    sender.userInteractionEnabled = YES;
}

#pragma mark --- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y + self.headerHeight;
    
    if (offsetY <= 0) { // 开始状态
        self.viewManager.headerView.mj_y = 64+CA_H_MANAGER.xheight;
        
        self.titleLb.textAlignment= NSTextAlignmentLeft;
        self.titleLb.font = self.viewManager.headerView.titleLb.font;
        
        self.titleLb.frame = [self.viewManager.headerView convertRect:self.viewManager.frame toView:self.view];
        
        self.viewManager.headerView.introLb.alpha = 1;
    } else if (offsetY >= self.headerHeight)  {// 结束状态
        self.viewManager.headerView.bottom =  64+CA_H_MANAGER.xheight;
        
        self.titleLb.textAlignment= NSTextAlignmentCenter;
        self.titleLb.font = self.viewManager.titleLb.font;
        self.titleLb.frame = [self.viewManager.naviView convertRect:self.viewManager.titleLb.frame toView:self.view];
        
        self.viewManager.headerView.introLb.alpha = 0.;
    } else {
        self.viewManager.headerView.mj_y = 64+CA_H_MANAGER.xheight - offsetY;
        
        self.viewManager.headerView.introLb.alpha = 1-(offsetY / (self.viewManager.headerView.titleLb.bottom+5*2*CA_H_RATIO_WIDTH));
        
        {

            CGRect frame = self.viewManager.headerView.titleLb.frame ;
            frame.origin.y += 64+CA_H_MANAGER.xheight;
            CGFloat lineHeight = self.titleLb.font.lineHeight;
            CGFloat labelHeight = frame.size.height - lineHeight*ceilf((offsetY-5*CA_H_RATIO_WIDTH)/lineHeight);
            
            if (labelHeight <= 30*CA_H_RATIO_WIDTH) { // label 二段变化
                CGFloat height = self.headerHeight - offsetY;
                
                CGFloat change = 1-height/(self.headerHeight-frame.size.height+30*CA_H_RATIO_WIDTH);
                
                frame.size.height = 30*CA_H_RATIO_WIDTH;

                self.titleLb.textAlignment= NSTextAlignmentCenter;

                CGFloat font = 22*CA_H_RATIO_WIDTH+(18-22*CA_H_RATIO_WIDTH)*change;
                self.titleLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:font];

                self.titleLb.height = 30*CA_H_RATIO_WIDTH;
                if (frame.size.width > self.viewManager.titleLb.frame.size.width) {
                    self.titleLb.width = frame.size.width+(self.viewManager.titleLb.frame.size.width-frame.size.width)*change;
                }

                CGPoint point0 = CGRectGetCenter(frame);
                CGPoint point1 = [self.viewManager.naviView convertPoint:self.viewManager.titleLb.center toView:self.view];
                self.titleLb.center = CGPointMake(point0.x+(point1.x-point0.x)*change, point0.y+(point1.y-point0.y)*change);

            }
            else if (labelHeight > frame.size.height) { // label固定
                self.titleLb.font = CA_H_FONT_PFSC_Medium(22);
                self.titleLb.textAlignment= NSTextAlignmentLeft;
                self.titleLb.frame = frame;
            }
            else { // label 一段变化
                self.titleLb.font = CA_H_FONT_PFSC_Medium(22);
                self.titleLb.textAlignment= NSTextAlignmentLeft;
                frame.size.height = labelHeight;
                self.titleLb.frame = frame;
            }
        }

    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.isFinished) {
        return self.viewModel.headerTitles.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//投资机构模块
        return 1;
    }else if (section == 1) {//工商追踪
        return 0;
    }else if (section == 2) {//描述信息
        return 1;
    }else if (section == 3) {//机构成员
//        if (self.viewModel.detailModel.member_dict.total_count.intValue > 3) {
//            return 3;
//        }
        return self.viewModel.detailModel.member_dict.member_list.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//投资机构模块
        CA_MDiscoverSponsorDetailItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"DetailItemCell"];
        self.cellHeight =  [itemCell configCell:self.viewModel.detailModel.gp_moudle];
        CA_H_WeakSelf(self)
        itemCell.pushBlock = ^(CA_MDiscoverSponsorLp_moudle *model) {
            CA_H_StrongSelf(self)
            CA_MDiscoverInvestmentManageFoundsVC *manageFoundsVC = [CA_MDiscoverInvestmentManageFoundsVC new];
            manageFoundsVC.data_type = model.module_type;
            manageFoundsVC.gp_id = self.data_id;
            [self.navigationController pushViewController:manageFoundsVC animated:YES];
        };
        return itemCell;
    }else if (indexPath.section == 1) {//工商追踪
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }else if (indexPath.section == 2) {// 描述信息
        CA_MDiscoverInvestmentDetailIntroCell *introCell = [tableView dequeueReusableCellWithIdentifier:@"DetailIntroCell"];
        introCell.model = self.viewModel.detailModel;
        return introCell;
    }
    //机构成员
    CA_MDiscoverProjectDetailCorePersonCell *corePersonCell = [tableView dequeueReusableCellWithIdentifier:@"CorePersonCell"];
    corePersonCell.lineView.hidden = YES;
    corePersonCell.model = self.viewModel.detailModel.member_dict.member_list[indexPath.row];
    CA_H_WeakSelf(self)
    corePersonCell.nameLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        NSLog(@"%@",self.viewModel.detailModel.member_dict.member_list[indexPath.row]);
    };
    [corePersonCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return corePersonCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//投资机构模块
        return self.cellHeight;
    }else if (indexPath.section == 1) {//工商追踪
        return CGFLOAT_MIN;
    }else if (indexPath.section == 2) {//描述信息
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.detailModel keyPath:@"model" cellClass:[CA_MDiscoverInvestmentDetailIntroCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 3) {//机构成员
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.detailModel.member_dict.member_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailCorePersonCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    return ({
        CA_MDiscoverProjectDetailSectionHeaderView *sectionView = [CA_MDiscoverProjectDetailSectionHeaderView new];
        sectionView.showArrowImg = (section == 1)? NO : YES;
        sectionView.title = self.viewModel.headerTitles[section];
        if (section == 1) {//工商追踪
            if (self.viewModel.detailModel.base_info.business_trace_total_count.intValue <= 0){
                sectionView = nil;
            }else{
                sectionView.title =
                [NSString stringWithFormat:@"%@（%@）",self.viewModel.headerTitles[section],self.viewModel.detailModel.base_info.business_trace_total_count];
            }
        }else if (section == 3) {//机构成员
            if (![NSObject isValueableObject:self.viewModel.detailModel.member_dict.member_list]) {
                sectionView = nil;
            }else{
//                sectionView.title =
//                [NSString stringWithFormat:@"%@（%@）",self.viewModel.headerTitles[section],self.viewModel.detailModel.member_dict.total_count];
                
                sectionView.title = self.viewModel.headerTitles[section];
            }
        }
        CA_H_WeakSelf(self)
        __block NSInteger weakSection = section;
        sectionView.didSelected = ^{
            CA_H_StrongSelf(self)
            if (weakSection == 1) {
                CA_MDiscoverInvestmentCommerceVC *commerceVC = [CA_MDiscoverInvestmentCommerceVC new];
                commerceVC.data_id = self.data_id;
                [self.navigationController pushViewController:commerceVC animated:YES];
            }
        };
        sectionView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1) {//工商追踪
        if (self.viewModel.detailModel.base_info.business_trace_total_count.intValue > 0) {
            return 32*2*CA_H_RATIO_WIDTH;
        }
    }else if (section == 2) {//描述信息
        return 32*2*CA_H_RATIO_WIDTH;
    }else if (section == 3) {//机构成员
        if ([NSObject isValueableObject:self.viewModel.detailModel.member_dict.member_list]) {
            return 32*2*CA_H_RATIO_WIDTH;
        }
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 3) {
//        if (self.viewModel.detailModel.member_dict.total_count.intValue > 3) {
//            return ({CA_MDiscoverProjectDetailSectionFooterView *footerView = [CA_MDiscoverProjectDetailSectionFooterView new];
//                footerView.title = @"查看更多机构成员";
//                CA_H_WeakSelf(self)
//                __block NSInteger weakSection = section;
//                footerView.pushBlock = ^{
//                    CA_H_StrongSelf(self)
//                    CA_MDiscoverInvestmentMemberListVC *memberListVC = [CA_MDiscoverInvestmentMemberListVC new];
//                    memberListVC.gp_id = self.data_id;
//                    [self.navigationController pushViewController:memberListVC animated:YES];
//                };
//                footerView;
//            });
//        }
//    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 3) {
//        if (self.viewModel.detailModel.member_dict.total_count.intValue > 3) {
//            return 26*2*CA_H_RATIO_WIDTH;
//        }
//    }
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        _titleLb.font = CA_H_FONT_PFSC_Medium(22);
        _titleLb.textColor = kColor(@"#FFFFFF");
    }
    return _titleLb;
}

-(CA_MDiscoverInvestmentDetailViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverInvestmentDetailViewManager new];
        [_viewManager customNaviViewWithTarget:self action:@selector(onNavBar:)];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        _viewManager.tableView.contentInset  = UIEdgeInsetsMake(40*2*CA_H_RATIO_WIDTH, 0, 0, 0);
        [_viewManager.tableView setContentOffset:CGPointMake(0, -(40*2*CA_H_RATIO_WIDTH))];
        CA_H_WeakSelf(self)
        _viewManager.headerView.titleLb.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self)
            self.viewManager.frame = frame;
            [self scrollViewDidScroll:self.viewManager.tableView];
        };
    }
    return _viewManager;
}

-(CA_MDiscoverInvestmentDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverInvestmentDetailViewModel new];
//        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.loadingView = CA_H_MANAGER.mainWindow;
        _viewModel.data_id = self.data_id;
        [_viewModel detailModel];
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            
            [self.viewManager configViewWithModel:self.viewModel.detailModel block:^(CGFloat height) {
                CA_H_StrongSelf(self)
                
                self.viewManager.titleLb.text = self.viewModel.detailModel.base_info.gp_name;
                
                self.titleLb.text = self.viewModel.detailModel.base_info.gp_name;
                
                self.headerHeight = height;
                
                [self setConstrains];
                
                self.viewManager.tableView.contentInset  = UIEdgeInsetsMake(height, 0, 0, 0);
                [self.viewManager.tableView setContentOffset:CGPointMake(0, -height)];
                
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self.viewManager.tableView reloadData];
                    [self.viewManager.tableView layoutIfNeeded];
                });
                
            }];
        };
    }
    return _viewModel;
}

@end
