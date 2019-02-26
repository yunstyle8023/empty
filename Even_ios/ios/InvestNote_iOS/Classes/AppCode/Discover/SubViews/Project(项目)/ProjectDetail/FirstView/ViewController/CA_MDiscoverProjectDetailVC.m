//
//  CA_MDiscoverProjectDetailVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverProjectDetailViewManager.h"
#import "CA_MDiscoverProjectDetailViewModel.h"
#import "CA_MDiscoverProjectDetailHeaderView.h"
#import "CA_MDiscoverProjectDetailAddView.h"
#import "CA_MDiscoverProjectDetailSectionHeaderView.h"
#import "CA_MDiscoverProjectDetailSectionFooterView.h"
#import "CA_MDiscoverProjectDetailInfoCell.h"
#import "CA_MDiscoverProjectDetailFinancInfoCell.h"
#import "CA_MDiscoverProjectDetailCorePersonCell.h"
#import "CA_MDiscoverProjectDetailProductCell.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MDiscoverRelatedPersonVC.h"
#import "CA_MDiscoverProjectDetailCorePersonVC.h"
#import "CA_MDiscoverProjectDetailProductVC.h"
#import "CA_MDiscoverRelatedProjectVC.h"
#import "CA_MDiscoverRelatedNewsVC.h"
#import "CA_HLongViewController.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MDiscoverProjectDetailTagVC.h"
#import "CA_MSelectModelDetail.h"
#import "CA_MDiscoverInvestmentDetailVC.h"
#import "CA_HBusinessDetailsController.h"
#import "CA_MDiscoverProjectH5VC.h"
#import "CA_MAddProjectVC.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverProjectDetailVC ()
<
UITableViewDataSource,
UITableViewDelegate,
CA_MDiscoverProjectDetailViewManagerDelegate
>

@property (nonatomic,strong) CA_MDiscoverProjectDetailViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverProjectDetailViewModel *viewModel;

@end

@implementation CA_MDiscoverProjectDetailVC

-(void)dealloc{
    [self.viewManager.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

- (void)upView{
    
    self.navigationItem.titleView = self.viewManager.titleView;
    
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 20;
    self.navigationItem.rightBarButtonItems = @[self.viewManager.sharBarBtnItem, spaceItem, self.viewManager.shotBarBtnItem];
    
    [self.view addSubview:self.viewManager.scrollView];
    self.viewManager.scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.view addSubview:self.viewManager.addView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.isFinished) {
        return self.viewModel.detailModel.headerTitles.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//项目信息
        return 1;
    }else if (section == 1) {//融资信息
        return self.viewModel.detailModel.invest_history_list.count;
    }else if (section == 2) {//核心人员
        return self.viewModel.detailModel.member_data.member_list.count;
    }else if (section == 3) {//产品
        return self.viewModel.detailModel.product_data.product_list.count;
    }else if (section == 4) {//相关竞品
        return self.viewModel.detailModel.compatible_project_data.compatible_project_list.count;
    }else if (section == 5) {//相关新闻
        return self.viewModel.detailModel.news_data.news_list.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_H_WeakSelf(self)
    if (indexPath.section == 1) {//融资信息
        CA_MDiscoverProjectDetailFinancInfoCell *financInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FinancInfoCell"];
        CA_MDiscoverInvestHistory_list *model = self.viewModel.detailModel.invest_history_list[indexPath.row];
        financInfoCell.model = model;
        financInfoCell.lineView.hidden = indexPath.row == (self.viewModel.detailModel.invest_history_list.count-1);
        financInfoCell.pushBlock = ^(NSIndexPath *indexPath, CA_MDiscoverGp_list *model) {
            CA_H_StrongSelf(self)
            CA_MDiscoverInvestmentDetailVC *investmentVC = [CA_MDiscoverInvestmentDetailVC new];
            investmentVC.data_id = model.data_id;
            [self.navigationController pushViewController:investmentVC animated:YES];
        };
        [financInfoCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return financInfoCell;
    }else if (indexPath.section == 2) {//核心人员
        CA_MDiscoverProjectDetailCorePersonCell *corePersonCell = [tableView dequeueReusableCellWithIdentifier:@"CorePersonCell"];
        corePersonCell.lineView.hidden = YES;
        corePersonCell.model = self.viewModel.detailModel.member_data.member_list[indexPath.row];
        corePersonCell.nameLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
            relatedPersonVC.enterprise_str = self.viewModel.detailModel.enterprise_name;
            relatedPersonVC.personName = self.viewModel.detailModel.member_data.member_list[indexPath.row].member_name;
            [self.navigationController pushViewController:relatedPersonVC animated:YES];
        };
        [corePersonCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return corePersonCell;
    }else if (indexPath.section == 3) {//产品
        CA_MDiscoverProjectDetailProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
        productCell.lineView.hidden = YES;
        productCell.model = self.viewModel.detailModel.product_data.product_list[indexPath.row];
        [productCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return productCell;
    }else if (indexPath.section == 4) {//相关竞品
        CA_MDiscoverProjectDetailRelatedProductCell *relatedProjectCell = [tableView dequeueReusableCellWithIdentifier:@"RelatedProjectCell"];
        relatedProjectCell.lineView.hidden = YES;
        relatedProjectCell.model = self.viewModel.detailModel.compatible_project_data.compatible_project_list[indexPath.row];
        relatedProjectCell.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
            CA_H_StrongSelf(self)
//            CA_MDiscoverProjectDetailTagVC *tagVC = [CA_MDiscoverProjectDetailTagVC new];
//            tagVC.tagName = tagName;
//            [self.navigationController pushViewController:tagVC animated:YES];
        };
        [relatedProjectCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return relatedProjectCell;
    }else if (indexPath.section == 5) {//相关新闻
        CA_MDiscoverProjectDetailNewsCell *newsCel = [tableView dequeueReusableCellWithIdentifier:@"NewsCel"];
        newsCel.lineView.hidden = YES;
        newsCel.model = self.viewModel.detailModel.news_data.news_list[indexPath.row];
        [newsCel useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return newsCel;
    }

    CA_MDiscoverProjectDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    if (self.viewModel.isFinished) {
        infoCell.model = self.viewModel.detailModel;
    }
    infoCell.companyLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        
        if (![NSString isValueableString:self.viewModel.detailModel.enterprise_keyno]) {
            return ;
        }
        
        CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
        vc.modelManager.dataStr = self.viewModel.detailModel.enterprise_name;
        [self.navigationController pushViewController:vc animated:YES];
    };
    infoCell.representativeLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        
        if (![NSString isValueableString:self.viewModel.detailModel.oper_name]) {
            return ;
        }
        
        CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
        relatedPersonVC.enterprise_str = self.viewModel.detailModel.enterprise_name;
        relatedPersonVC.personName = self.viewModel.detailModel.oper_name;
        [self.navigationController pushViewController:relatedPersonVC animated:YES];
    };
    [infoCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return infoCell;
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {//核心人员
        CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
        relatedPersonVC.enterprise_str = self.viewModel.detailModel.enterprise_name;
        relatedPersonVC.personName = self.viewModel.detailModel.member_data.member_list[indexPath.row].member_name;
        [self.navigationController pushViewController:relatedPersonVC animated:YES];
        
    }else if (indexPath.section == 3){//产品
        CA_MDiscoverProduct_list *model = self.viewModel.detailModel.product_data.product_list[indexPath.row];
        if (![NSString isValueableString:model.product_name]) {
            return;
        }
        CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
        h5VC.urlStr = model.product_website;
        [self.navigationController pushViewController:h5VC animated:YES];
    }else if (indexPath.section == 4){//相关竞品
        CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
        CA_MDiscoverCompatible_project_list *model = self.viewModel.detailModel.compatible_project_data.compatible_project_list[indexPath.row];
        projectDetailVC.dataID = model.data_id;
        [self.navigationController pushViewController:projectDetailVC animated:YES];
    }else if (indexPath.section == 5){//相关新闻
        CA_MDiscoverNews_list *model = self.viewModel.detailModel.news_data.news_list[indexPath.row];
        CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
        h5VC.urlStr = model.news_url;
        [self.navigationController pushViewController:h5VC animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//融资信息
        return [tableView cellHeightForIndexPath:indexPath
                                    model:self.viewModel.detailModel.invest_history_list[indexPath.row]
                                  keyPath:@"model"
                                cellClass:[CA_MDiscoverProjectDetailFinancInfoCell class]
                         contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 2) {//核心人员
        return [tableView cellHeightForIndexPath:indexPath
                                           model:self.viewModel.detailModel.member_data.member_list[indexPath.row]
                                         keyPath:@"model"
                                       cellClass:[CA_MDiscoverProjectDetailCorePersonCell class]
                                contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 3) {//产品
        return [tableView cellHeightForIndexPath:indexPath
                                           model:self.viewModel.detailModel.product_data.product_list[indexPath.row]
                                         keyPath:@"model"
                                       cellClass:[CA_MDiscoverProjectDetailProductCell class]
                                contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 4) {//相关竞品
        return [tableView cellHeightForIndexPath:indexPath
                                           model:self.viewModel.detailModel.compatible_project_data.compatible_project_list[indexPath.row]
                                         keyPath:@"model"
                                       cellClass:[CA_MDiscoverProjectDetailRelatedProductCell class]
                                contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (indexPath.section == 5) {//相关新闻
        return [tableView cellHeightForIndexPath:indexPath
                                           model:self.viewModel.detailModel.news_data.news_list[indexPath.row]
                                         keyPath:@"model"
                                       cellClass:[CA_MDiscoverProjectDetailNewsCell class]
                                contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath
                                       model:self.viewModel.detailModel
                                     keyPath:@"model"
                                   cellClass:[CA_MDiscoverProjectDetailInfoCell class]
                            contentViewWidth:CA_H_SCREEN_WIDTH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverProjectDetailSectionHeaderView *sectionView = [CA_MDiscoverProjectDetailSectionHeaderView new];
        if (section == 1) {//融资信息
            if (![NSObject isValueableObject:self.viewModel.detailModel.invest_history_list]) {
                sectionView = nil;
            }else{
               sectionView.title = self.viewModel.detailModel.headerTitles[section];
            }
        }else if (section == 2) {//核心人员
            if (![NSObject isValueableObject:self.viewModel.detailModel.member_data.member_list]) {
                sectionView = nil;
            }else{
                sectionView.title = self.viewModel.detailModel.headerTitles[section];
            }
        }else if (section == 3) {//产品
            if (![NSObject isValueableObject:self.viewModel.detailModel.product_data.product_list]) {
                sectionView = nil;
            }else{
                sectionView.title = [NSString stringWithFormat:@"%@ （%@）",self.viewModel.detailModel.headerTitles[section],self.viewModel.detailModel.product_data.total_count];
            }
        }else if (section == 4) {//相关竞品
            if (![NSObject isValueableObject:self.viewModel.detailModel.compatible_project_data.compatible_project_list]) {
                sectionView = nil;
            }else{
                sectionView.title = [NSString stringWithFormat:@"%@ （%@）",self.viewModel.detailModel.headerTitles[section],self.viewModel.detailModel.compatible_project_data.total_count];
            }
        }else if (section == 5) {//相关新闻
            if (![NSObject isValueableObject:self.viewModel.detailModel.news_data.news_list]) {
                sectionView = nil;
            }else{
                sectionView.title = [NSString stringWithFormat:@"%@ （%@）",self.viewModel.detailModel.headerTitles[section],self.viewModel.detailModel.news_data.total_count];
            }
        }else{
            if (!self.viewModel.isFinished) {
                sectionView = nil;
            }else{
                sectionView.title = self.viewModel.detailModel.headerTitles[section];
            }
        }
        sectionView.lineView.hidden = (section == 0);
        sectionView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {//融资信息
        if (![NSObject isValueableObject:self.viewModel.detailModel.invest_history_list]) {
            return CGFLOAT_MIN;
        }
    }else if (section == 2) {//核心人员
        if (![NSObject isValueableObject:self.viewModel.detailModel.member_data.member_list]) {
            return CGFLOAT_MIN;
        }
    }else if (section == 3) {//产品
        if (![NSObject isValueableObject:self.viewModel.detailModel.product_data.product_list]) {
            return CGFLOAT_MIN;
        }
    }else if (section == 4) {//相关竞品
        if (![NSObject isValueableObject:self.viewModel.detailModel.compatible_project_data.compatible_project_list]) {
            return CGFLOAT_MIN;
        }
    }else if (section == 5) {//相关新闻
        if (![NSObject isValueableObject:self.viewModel.detailModel.news_data.news_list]) {
            return CGFLOAT_MIN;
        }
    }else{
        if (!self.viewModel.isFinished) {
            return CGFLOAT_MIN;
        }
    }
    return 27*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0
        ||
        section == 1) {
        return nil;
    }
    return ({
        CA_MDiscoverProjectDetailSectionFooterView *footerView = [CA_MDiscoverProjectDetailSectionFooterView new];
        footerView.title = self.viewModel.detailModel.footerTitles[section];
        CA_H_WeakSelf(self)
        __block NSInteger weakSection = section;
        footerView.pushBlock = ^{
            CA_H_StrongSelf(self)
            if (weakSection == 2) {//核心人员
                CA_MDiscoverProjectDetailCorePersonVC *corePersonVC = [CA_MDiscoverProjectDetailCorePersonVC new];
                corePersonVC.enterprise_str = self.viewModel.detailModel.enterprise_name;
                corePersonVC.data_type = self.viewModel.detailModel.member_data.data_type;
                corePersonVC.dataID = self.dataID;
                [self.navigationController pushViewController:corePersonVC animated:YES];
            }else if (weakSection == 3) {//产品
                CA_MDiscoverProjectDetailProductVC *productVC = [CA_MDiscoverProjectDetailProductVC new];
                productVC.data_type = self.viewModel.detailModel.product_data.data_type;
                productVC.dataID = self.dataID;
                [self.navigationController pushViewController:productVC animated:YES];
            }else if (weakSection == 4) {//相关竞品
                CA_MDiscoverRelatedProjectVC *relatedProjectVC = [CA_MDiscoverRelatedProjectVC new];
                relatedProjectVC.data_type = self.viewModel.detailModel.compatible_project_data.data_type;
                relatedProjectVC.dataID = self.dataID;
                [self.navigationController pushViewController:relatedProjectVC animated:YES];
            }else if (weakSection == 5) {//相关新闻
                CA_MDiscoverRelatedNewsVC *newsVC = [CA_MDiscoverRelatedNewsVC new];
                newsVC.data_type = self.viewModel.detailModel.news_data.data_type;
                newsVC.dataID = self.dataID;
                [self.navigationController pushViewController:newsVC animated:YES];
            }
        };
        if (section == 2) {//核心人员
            footerView.hidden = self.viewModel.detailModel.member_data.total_count.intValue <= 3;
        }else if (section == 3) {//产品
            footerView.hidden = self.viewModel.detailModel.product_data.total_count.intValue <= 3;
        }else if (section == 4) {//相关竞品
            footerView.hidden = self.viewModel.detailModel.compatible_project_data.total_count.intValue <= 3;
        }else if (section == 5) {//相关新闻
            footerView.hidden = self.viewModel.detailModel.news_data.total_count.intValue <= 3;
        }
        footerView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {//核心人员
        return self.viewModel.detailModel.member_data.total_count.intValue > 3 ? 26*2*CA_H_RATIO_WIDTH : CGFLOAT_MIN;
    }else if (section == 3) {//产品
        return self.viewModel.detailModel.product_data.total_count.intValue > 3 ? 26*2*CA_H_RATIO_WIDTH : CGFLOAT_MIN;
    }else if (section == 4) {//相关竞品
        return self.viewModel.detailModel.compatible_project_data.total_count.intValue > 3 ? 26*2*CA_H_RATIO_WIDTH : CGFLOAT_MIN;
    }else if (section == 5) {//相关新闻
        return self.viewModel.detailModel.news_data.total_count.intValue > 3 ? 26*2*CA_H_RATIO_WIDTH : CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id oldName = [change objectForKey:NSKeyValueChangeOldKey];
    id newName = [change objectForKey:NSKeyValueChangeNewKey];
    //当界面要消失的时候,移除kvo
    CGSize size = [newName CGSizeValue];
    if (size.height > 0) {
        self.viewManager.tableView.size = size;
        self.viewManager.scrollView.contentSize = size;
    }
    
}

#pragma mark - CA_MDiscoverProjectDetailViewManagerDelegate

- (void)clickShotBarBtnClick{
    
    UIImage *marginImg = [UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *image = [self.viewManager.tableView snapshotImage];
    
    CGFloat width = image.size.width;
    CGFloat height = 20 + image.size.height;
    
    CGSize resultSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(resultSize, YES, 0.);
    
    //放第一个图片
    CGRect oneRect = CGRectMake(0, 0, resultSize.width, 20);
    [marginImg drawInRect:oneRect];
    
    //放第二个图片
    CGRect otherRect = CGRectMake(0, oneRect.size.height, resultSize.width, image.size.height);
    [image drawInRect:otherRect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CA_HLongViewController* longViewVC = [CA_HLongViewController new];
    longViewVC.type = CA_HLongTypeFound;
    longViewVC.image = resultImage;
    [self.navigationController pushViewController:longViewVC animated:YES];
}

- (void)clickSharBarBtnClick{
    [CA_H_MANAGER shareDetail:self data_type:@"project" data_id:self.dataID block:nil];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = scrollView.contentOffset.y / 124*CA_H_RATIO_WIDTH;
    self.viewManager.titleView.titleLabel.alpha = alpha;
    
    if (scrollView.contentOffset.y >= self.viewManager.tableView.tableHeaderView.mj_h) {
        [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    }else {
        [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    }
}

#pragma mark - getter and setter

-(CA_MDiscoverProjectDetailViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverProjectDetailViewManager new];
        _viewManager.scrollView.delegate = self;
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        _viewManager.delegate = self;
        //
        [_viewManager.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        CA_H_WeakSelf(self)
        _viewManager.headerView.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectDetailTagVC *tagVC = [CA_MDiscoverProjectDetailTagVC new];
            tagVC.tagName = tagName;
            [self.navigationController pushViewController:tagVC animated:YES];
        };
        _viewManager.addView.pushBlock = ^{
            CA_H_StrongSelf(self)
            CA_MAddProjectVC* addProjectVC = [[CA_MAddProjectVC alloc] init];
            addProjectVC.find = YES;
            CA_MSelectModelDetail *detailModel = [CA_MSelectModelDetail new];
            detailModel.data_id = self.dataID;
            detailModel.project_name = self.viewModel.detailModel.project_name;
            
            if (self.viewModel.detailModel.invest_stage_id) {
                detailModel.project_invest_stage = self.viewModel.detailModel.project_invest_stage;
                detailModel.invest_stage_id = self.viewModel.detailModel.invest_stage_id;
            }
            addProjectVC.detailModel = detailModel;
            [self.navigationController pushViewController:addProjectVC animated:YES];
        };
    }
    return _viewManager;
}

-(CA_MDiscoverProjectDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverProjectDetailViewModel new];
        _viewModel.loadingView = self.viewManager.scrollView;
        _viewModel.dataID = self.dataID;
        [_viewModel detailModel];
        CA_H_WeakSelf(self);
        _viewModel.finishedBlock = ^(){
            CA_H_StrongSelf(self);
            
            self.viewManager.addView.hidden = NO;
            [self.viewManager.titleView setTitle:self.viewModel.detailModel.project_name forState:UIControlStateNormal];
            self.viewManager.model = self.viewModel.detailModel;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self.viewManager.tableView reloadData];
            });
        };
    }
    return _viewModel;
}


@end












