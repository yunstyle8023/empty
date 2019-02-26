
//
//  CA_MDiscoverSponsorDetailVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailVC.h"
#import "CA_MDiscoverSponsorDetailViewManager.h"
#import "CA_MDiscoverSponsorDetailViewModel.h"
#import "CA_MDiscoverSponsorDetailHeaderView.h"
#import "CA_MDiscoverSponsorDetailItemCell.h"
#import "CA_MDiscoverSponsorDetailinfoCell.h"
#import "CA_MDiscoverSponsorDetailuUnfoldCell.h"
#import "CA_MDiscoverSponsorDetailMemberCell.h"
#import "CA_MDiscoverProjectDetailSectionHeaderView.h"
#import "CA_MDiscoverSponsorDetailBottomView.h"
#import "CA_MDiscoverSponsorDetailContactView.h"
#import "CA_MDiscoverSponsorDetailModel.h"
#import "CA_MDiscoverSponsorListVC.h"
#import "CA_MDiscoverSponsorItemProjectVC.h"
#import "CA_MDiscoverSponsorItemInvestVC.h"
#import "CA_HFoundFactoryPattern.h"
#import "CA_HBusinessDetailsController.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverSponsorDetailVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverSponsorDetailViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverSponsorDetailViewModel *viewModel;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation CA_MDiscoverSponsorDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
    [self setConstrains];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewManager.bottomView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.viewManager.bottomView.hidden = YES;
}

-(void)upView{
    self.navBarHidden = YES;
    
    [self.view addSubview:self.viewManager.naviView];

    [self.view addSubview:self.viewManager.headerView];

    [self.view addSubview:self.viewManager.tableView];

    [self.view addSubview:self.viewManager.bottomView];
    
    [self.view bringSubviewToFront:self.viewManager.headerView];
    
    [self.view bringSubviewToFront:self.viewManager.naviView];

    [self.view addSubview:self.viewManager.contactView];
    
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
//    .topSpaceToView(self.view, 64+CA_H_MANAGER.xheight)
    .rightEqualToView(self.view)
    .heightIs(self.headerHeight);
    self.viewManager.headerView.mj_y = 64+CA_H_MANAGER.xheight;
    
    self.viewManager.bottomView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(25*2*CA_H_RATIO_WIDTH);
    
    self.viewManager.tableView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 64+CA_H_MANAGER.xheight)
    .bottomSpaceToView(self.view, self.viewManager.bottomView.mj_h);
    
    self.viewManager.contactView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
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
            [CA_H_MANAGER shareDetail:self data_type:@"lp" data_id:self.data_id block:nil];
            break;
        case 102: //长图
            self.viewManager.bottomView.hidden = YES;
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
        
        self.viewManager.headerView.detailLb.alpha = 1;
        self.viewManager.headerView.collectionView.alpha = 1;
    } else if (offsetY >= self.headerHeight)  {// 结束状态
        self.viewManager.headerView.bottom =  64+CA_H_MANAGER.xheight;
        
        self.titleLb.textAlignment= NSTextAlignmentCenter;
        self.titleLb.font = self.viewManager.titleLb.font;
        self.titleLb.frame = [self.viewManager.naviView convertRect:self.viewManager.titleLb.frame toView:self.view];
        
        self.viewManager.headerView.detailLb.alpha = 0.;
        self.viewManager.headerView.collectionView.alpha = 0.;
    } else {
        self.viewManager.headerView.mj_y = 64+CA_H_MANAGER.xheight - offsetY;
        self.viewManager.headerView.detailLb.alpha = 1-(offsetY / (self.viewManager.headerView.titleLb.bottom+5*2*CA_H_RATIO_WIDTH));
        self.viewManager.headerView.collectionView.alpha = 1-(offsetY / (self.viewManager.headerView.titleLb.bottom+5*2*CA_H_RATIO_WIDTH));
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
        return self.viewModel.detailModel.headerTitles.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//出资人模块
        return 1;
    }else if (section == 1) {//基本信息
        return 1;
    }else if (section == 2) {//国有背景详情
        return [NSString isValueableString:self.viewModel.detailModel.base_info.state_background]?1:0;
    }else if (section == 3) {//描述信息
        return [NSString isValueableString:self.viewModel.detailModel.base_info.lp_desc]?1:0;
    }else if (section == 4) {//主要成员
        return self.viewModel.detailModel.member_list.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//出资人模块
        CA_MDiscoverSponsorDetailItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorDetailItemCell"];
        self.cellHeight =  [itemCell configCell:self.viewModel.detailModel.lp_moudle];
        CA_H_WeakSelf(self)
        itemCell.pushBlock = ^(CA_MDiscoverSponsorLp_moudle *model) {
            CA_H_StrongSelf(self)
            if ([model.module_type isEqualToString:@"invest_fund"]) {//投资基金
                CA_MDiscoverSponsorItemInvestVC *investVC = [CA_MDiscoverSponsorItemInvestVC new];
                investVC.lpId = model.data_id;
                [self.navigationController pushViewController:investVC animated:YES];
            }else if ([model.module_type isEqualToString:@"invest_project"]) {//投资项目
                CA_MDiscoverSponsorItemProjectVC *projectVC = [CA_MDiscoverSponsorItemProjectVC new];
                projectVC.lpID = model.data_id;
                [self.navigationController pushViewController:projectVC animated:YES];
            }
        };
        return itemCell;
    }else if (indexPath.section == 1) {//基本信息
        CA_MDiscoverSponsorDetailinfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorDetailinfoCell"];
        infoCell.model = self.viewModel.detailModel;
        CA_H_WeakSelf(self)
        infoCell.chOrganizationLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
            vc.modelManager.dataStr = self.viewModel.detailModel.base_info.lp_name;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [infoCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return infoCell;
    }else if (indexPath.section == 2 || indexPath.section == 3) {// 国有背景详情  描述信息
        CA_MDiscoverSponsorDetailuUnfoldCell *unfoldCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorDetailuUnfoldCell"];
        self.cellHeight = [unfoldCell configCell:self.viewModel.detailModel indexPath:indexPath];
        CA_H_WeakSelf(self)
        __weak NSIndexPath *weakIndexPath = indexPath;
        unfoldCell.unfoldBlock = ^(BOOL isUnfold) {
            CA_H_StrongSelf(self)

            if (weakIndexPath.section == 2) {//国有背景
                self.viewModel.detailModel.base_info.state_background_unfold = isUnfold;
            }else if (weakIndexPath.section == 3) {//描述信息
                self.viewModel.detailModel.base_info.lp_desc_unfold = isUnfold;
            }
            
//            [self.viewManager.tableView reloadSection:weakIndexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.viewManager.tableView reloadData];
        };
        return unfoldCell;
    }
    //主要成员
    CA_MDiscoverSponsorDetailMemberCell *memberCell = [tableView dequeueReusableCellWithIdentifier:@"SponsorDetailMemberCell"];
    memberCell.model = self.viewModel.detailModel.member_list[indexPath.row];
    return memberCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//基本信息
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.detailModel keyPath:@"model" cellClass:[CA_MDiscoverSponsorDetailinfoCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 0 ||//项目模块
              indexPath.section == 2 ||//国有背景详情
              indexPath.section == 3) {//描述信息
        return self.cellHeight;
    }else if (indexPath.section == 4) {
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.detailModel.member_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverSponsorDetailMemberCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    return ({
        CA_MDiscoverProjectDetailSectionHeaderView *sectionView = [CA_MDiscoverProjectDetailSectionHeaderView new];
        sectionView.font = CA_H_FONT_PFSC_Medium(18);
        sectionView.title = self.viewModel.detailModel.headerTitles[section];
        if (section == 2) {//国有背景详情
            if (![NSString isValueableString:self.viewModel.detailModel.base_info.state_background]){
                sectionView = nil;
            }
        }else if (section == 3) {//描述信息
            if (![NSString isValueableString:self.viewModel.detailModel.base_info.lp_desc]){
                sectionView = nil;
            }
        }else if (section == 4) {//主要成员
            if (![NSObject isValueableObject:self.viewModel.detailModel.member_list]) {
                sectionView = nil;
            }
        }
        sectionView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    if (section == 2) {//国有背景详情
        if (![NSString isValueableString:self.viewModel.detailModel.base_info.state_background]){
            return CGFLOAT_MIN;
        }
    }else if (section == 3) {//描述信息
        if (![NSString isValueableString:self.viewModel.detailModel.base_info.lp_desc]){
            return CGFLOAT_MIN;
        }
    }else if (section == 4) {//主要成员
        if (![NSObject isValueableObject:self.viewModel.detailModel.member_list]) {
            return CGFLOAT_MIN;
        }
    }
    return 32*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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

-(CA_MDiscoverSponsorDetailViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverSponsorDetailViewManager new];
        [_viewManager customNaviViewWithTarget:self action:@selector(onNavBar:)];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.bottomView.selectBlock = ^{
            CA_H_StrongSelf(self)
            self.viewManager.contactView.hidden = NO;
        };
        _viewManager.contactView.lookBlock = ^(NSNumber *count){
          CA_H_StrongSelf(self)
//            self.viewManager.bottomView.count = count;
            self.viewManager.bottomView.isLook = YES;
        };
        _viewManager.headerView.pushBlock = ^(NSString *tag) {
            CA_H_StrongSelf(self)
            CA_MDiscoverSponsorListVC *listVC = [CA_MDiscoverSponsorListVC new];
            listVC.tag = tag;
            [self.navigationController pushViewController:listVC animated:YES];
        };
        
        _viewManager.headerView.titleLb.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self)
            self.viewManager.frame = frame;
            [self scrollViewDidScroll:self.viewManager.tableView];
        };
    }
    return _viewManager;
}

-(CA_MDiscoverSponsorDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverSponsorDetailViewModel new];
//        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.loadingView = CA_H_MANAGER.mainWindow;
        _viewModel.data_id = self.data_id;
        [_viewModel detailModel];
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            
            [self.viewManager configViewManager:self.viewModel.detailModel block:^(CGFloat height) {
                CA_H_StrongSelf(self)
                
                self.titleLb.text = self.viewModel.detailModel.base_info.lp_name;
                
                self.headerHeight = height;
                
                [self setConstrains];
                
                self.viewManager.tableView.contentInset  = UIEdgeInsetsMake(height, 0, 0, 0);
                [self.viewManager.tableView setContentOffset:CGPointMake(0, -height)];
                
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self.viewManager.tableView reloadData];
                    [self.viewManager.tableView layoutIfNeeded];
                });
                
            }];
            
            self.viewManager.contactView.data_id = self.data_id;
            
            if ((!self.viewModel.detailModel.contact_data)
//                &&
//                self.viewModel.detailModel.include_data.import_count.intValue > 0
                ) {
                self.viewManager.bottomView.count = self.viewModel.detailModel.include_data.import_count;
                self.viewManager.contactView.is_imported = NO;
                self.viewManager.contactView.count = self.viewModel.detailModel.include_data.import_count;
            }else{
                self.viewManager.contactView.is_imported = YES;
                self.viewManager.contactView.contact_data = self.viewModel.detailModel.contact_data;
            }
            
        };
    }
    return _viewModel;
}

@end
