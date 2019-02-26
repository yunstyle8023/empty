//
//  CA_MDiscoverInvestmentManageFoundsVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsVC.h"
#import "CA_MDiscoverInvestmentManageFoundsViewManager.h"
#import "CA_MDiscoverInvestmentManageFoundsViewModel.h"
#import "CA_MDiscoverInvestmentManageFoundsCell.h"
#import "CA_MDiscoverInvestmentFoundsCell.h"
#import "CA_MDiscoverInvestmentFoundsProjectCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_HBusinessDetailsController.h"
#import "CA_MDiscoverRelatedPersonVC.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentManageFoundsVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverInvestmentManageFoundsViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverInvestmentManageFoundsViewModel *viewModel;

@end

@implementation CA_MDiscoverInvestmentManageFoundsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)upView {
    self.navigationItem.title = self.viewModel.title;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.data_type isEqualToString:@"managed_fund"]) {//投资基金
        CA_MDiscoverInvestmentManageFoundsCell *manageFoundsCell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentManageFoundsCell"];
        CA_MDiscoverInvestmentManaged_FundModel *model = self.viewModel.dataSource[indexPath.row];
        manageFoundsCell.model = model;
        CA_H_WeakSelf(self)
        __weak CA_MDiscoverInvestmentManaged_FundModel *weakModel = model;
        manageFoundsCell.titleLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
            vc.modelManager.dataStr = weakModel.enterprise_name;
            [self.navigationController pushViewController:vc animated:YES];
        };
        manageFoundsCell.legalLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            if (![NSString isValueableString:weakModel.oper_name]) {
                return ;
            }
            CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
            relatedPersonVC.enterprise_str = weakModel.enterprise_name;
            relatedPersonVC.personName = weakModel.oper_name;
            [self.navigationController pushViewController:relatedPersonVC animated:YES];
        };
        [manageFoundsCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return manageFoundsCell;
    }else if ([self.data_type isEqualToString:@"foreign_investment_fund"]//对外投资基金
              ||
              [self.data_type isEqualToString:@"undisclosed_investment"]) {//未公开投资事件
        
        CA_MDiscoverInvestmentFoundsCell *foundsCell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentFoundsCell"];
        if ([self.data_type isEqualToString:@"foreign_investment_fund"]){
            foundsCell.legalLb.textColor = CA_H_4BLACKCOLOR;
        }else{
            foundsCell.legalLb.textColor = CA_H_TINTCOLOR;
        }
        CA_MDiscoverInvestmentInvestment_FundModel *model = self.viewModel.dataSource[indexPath.row];
        foundsCell.model = model;
        __weak CA_MDiscoverInvestmentInvestment_FundModel *weakModel = model;
        CA_H_WeakSelf(self)
        foundsCell.titleLb.didSelect = ^(ButtonLabel *sender) {//公司名称
            CA_H_StrongSelf(self)
            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
            vc.modelManager.dataStr = weakModel.enterprise_name;
            [self.navigationController pushViewController:vc animated:YES];
        };
        foundsCell.legalLb.didSelect = ^(ButtonLabel *sender) {//公司名称
            CA_H_StrongSelf(self)
            if ([self.data_type isEqualToString:@"foreign_investment_fund"]) {//对外投资基金
                return ;
            }
            if (![NSString isValueableString:weakModel.oper_name]) {
                return;
            }
            CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
            relatedPersonVC.enterprise_str = weakModel.enterprise_name;
            relatedPersonVC.personName = weakModel.oper_name;
            [self.navigationController pushViewController:relatedPersonVC animated:YES];
        };
        foundsCell.didSelectItem = ^(NSInteger item) {//投资方
            CA_H_StrongSelf(self)
            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
            vc.modelManager.dataStr = ((CA_MDiscoverInvestmentInvestor_ListModel*)weakModel.investor_list[item]).enterprise_name;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [foundsCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return foundsCell;
    }else if ([self.data_type isEqualToString:@"public_investment_event"]) {//公开投资事件
        CA_MDiscoverInvestmentFoundsProjectCell *foundsCell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentFoundsProjectCell"];
        foundsCell.model = self.viewModel.dataSource[indexPath.row];
        CA_H_WeakSelf(self)
        foundsCell.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
            CA_H_StrongSelf(self)
            NSLog(@"tagName == %@",tagName);
        };
        return foundsCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.data_type isEqualToString:@"public_investment_event"]) {
        CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
        CA_MDiscoverInvestmentPublic_Investment_EventdModel *model = self.viewModel.dataSource[indexPath.row];
        projectDetailVC.dataID = model.data_id;
        [self.navigationController pushViewController:projectDetailVC animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.data_type isEqualToString:@"managed_fund"]) {//投资基金
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverInvestmentManageFoundsCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if ([self.data_type isEqualToString:@"foreign_investment_fund"]//对外投资基金
              ||
              [self.data_type isEqualToString:@"undisclosed_investment"]) {//未公开投资事件
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverInvestmentFoundsCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if ([self.data_type isEqualToString:@"public_investment_event"]) {//公开投资事件
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverInvestmentFoundsProjectCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        UIView *header = [UIView new];
        header;
    });
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

#pragma mark - getter and setter

-(CA_MDiscoverInvestmentManageFoundsViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverInvestmentManageFoundsViewManager new];
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
    }
    return _viewManager;
}

-(CA_MDiscoverInvestmentManageFoundsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverInvestmentManageFoundsViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.data_type = self.data_type;
        _viewModel.gp_id = self.gp_id;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore, BOOL isHasData) {
            CA_H_StrongSelf(self)
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
