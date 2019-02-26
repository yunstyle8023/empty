//
//  CA_MDiscoverFinancingVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverFinancingVC.h"
#import "CA_MDiscoverFinancingViewManager.h"
#import "CA_MDiscoverViewModel.h"
#import "CA_MDiscoverModel.h"
#import "CA_MDiscoverProjectCell.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverFinancingSectionView.h"
#import "CA_MDiscoverInvestmentTopView.h"
#import "CA_HFilterMenu.h"
#import "CA_MDiscoverInvestmentModel.h"

@interface CA_MDiscoverFinancingVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverFinancingViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverViewModel *viewModel;

@property (nonatomic, strong) CA_HFilterMenu *filterView;
@property (nonatomic,assign) NSInteger currentSelectButton;//当前选中的哪个按钮

@property (nonatomic,copy) NSString *currentTimeStr;
@property (nonatomic,copy) NSString *currentRoundStr;
@property (nonatomic,copy) NSString *currentIndustryStr;
@property (nonatomic,copy) NSString *currentAreaStr;

@property (nonatomic, strong) NSArray *currentSelectData;
@end

@implementation CA_MDiscoverFinancingVC

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
    
    self.currentTimeStr = @"全部时间";
    self.currentRoundStr = @"全部阶段";
    self.currentIndustryStr = @"全部行业";
    self.currentAreaStr = @"全部地区";
    
}

-(void)upView{
    
    self.navigationItem.title = self.viewModel.title;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(20*2*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    [self.view addSubview:self.viewManager.topView];
    self.viewManager.topView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH)
    .heightIs(20*2*CA_H_RATIO_WIDTH);
    [CA_HFoundFactoryPattern showShadowWithView:self.viewManager.topView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.viewManager.tableView.scrollEnabled = self.viewModel.discoverModel.data_list.count>0;
    self.viewManager.tableView.backgroundView.hidden = self.viewModel.discoverModel.data_list.count>0;
    self.viewManager.tableView.mj_footer.hidden = self.viewModel.discoverModel.data_list.count==0;
    return self.viewModel.discoverModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverProjectCell *projectCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverProjectCell"];
    projectCell.model = self.viewModel.discoverModel.data_list[indexPath.row];
    [projectCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return projectCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    CA_MCommonModel *model = self.viewModel.discoverModel.data_list[indexPath.row];
    projectDetailVC.dataID = model.project_id;
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewManager.tableView cellHeightForIndexPath:indexPath model:self.viewModel.discoverModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverFinancingSectionView *headerView = [CA_MDiscoverFinancingSectionView new];
        headerView.totalCount = self.viewModel.discoverModel.total_count;
        headerView.hidden = self.viewModel.discoverModel.data_list.count==0;
        headerView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter
- (CA_HFilterMenu *)filterView {
    if (!_filterView) {
        _filterView = [CA_HFilterMenu new];
        _filterView.maxHeight = 148*2*CA_H_RATIO_WIDTH;
        _filterView.frame = CGRectMake(0, 37*CA_H_RATIO_WIDTH, self.view.width, self.view.height-37*CA_H_RATIO_WIDTH);
        [self.view addSubview:_filterView];
        
        CA_H_WeakSelf(self);
        _filterView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(self)
            
            [self.filterView hideMenu:YES];
            
            self.viewModel.filter = YES;
            
            if (item < 0 ) {

                for (UIButton *button in self.viewManager.topView.buttons) {
                    button.selected = NO;
                }
                
            }else {
                
                for (UIButton *button in self.viewManager.topView.buttons) {
                    if (button.tag == self.currentSelectButton) {
                        button.selected = NO;
                        break;
                    }
                }
                
                if (self.currentSelectButton == 100+1) {//地区
                    self.currentAreaStr = [self.currentSelectData objectAtIndex:item];
                    [self.viewManager.topView.firstBtn setTitle:self.currentAreaStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentAreaStr;
                }else if (self.currentSelectButton == 100+2) {//行业
                    self.currentIndustryStr = [self.currentSelectData objectAtIndex:item];
                    [self.viewManager.topView.secondBtn setTitle:self.currentIndustryStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentIndustryStr;
                }else if (self.currentSelectButton == 100+3) {//阶段
                    self.currentRoundStr = [self.currentSelectData objectAtIndex:item];
                    [self.viewManager.topView.thirdBtn setTitle:self.currentRoundStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentRoundStr;
                }else if (self.currentSelectButton == 100+4) {//日期
                    self.currentTimeStr = [self.currentSelectData objectAtIndex:item];
                    [self.viewManager.topView.fourBtn setTitle:self.currentTimeStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentTimeStr;
                }
                
                //@"time+round+industry+area";
                //@"全部时间+全部阶段+全部行业+全部地区";
                
                self.viewModel.search_str = [NSString stringWithFormat:@"%@+%@+%@+%@",
                 ([self.currentTimeStr isEqualToString:@"全部时间"]?@"全部时间":self.currentTimeStr),
                 ([self.currentRoundStr isEqualToString:@"全部阶段"]?@"全部阶段":self.currentRoundStr),
                 ([self.currentIndustryStr isEqualToString:@"全部行业"]?@"全部行业":self.currentIndustryStr),
                 ([self.currentAreaStr isEqualToString:@"全部地区"]?@"全部地区":self.currentAreaStr)];
                
                self.viewModel.refreshBlock();
            }
            
        };
        
    }
    return _filterView;
}
-(CA_MDiscoverFinancingViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverFinancingViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        
        CA_H_WeakSelf(self);
        
        _viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.refreshBlock();
        }];
        
        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.loadMoreBlock();
        }];
        
        _viewManager.topView.didSelected = ^(UIButton *button) {
            CA_H_StrongSelf(self)
            
            if (!button.isSelected) {
                [self.filterView hideMenu:YES];
                return ;
            }
            
            [self.viewModel loadFilterData:^(CA_MDiscoverInvestmentFilterData *filterData) {
                CA_H_StrongSelf(self)

                self.currentSelectButton = button.tag;
                
                for (UIButton *button in self.viewManager.topView.buttons) {
                    button.selected = (button.tag == self.currentSelectButton?YES:NO);
                }
                
                if (button.tag == 100+1) {//全部地区
                    self.currentSelectData = filterData.filter_area;
                    [self.viewManager.topView.firstBtn setTitle:self.currentAreaStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentAreaStr;
                }else if (button.tag == 100+2) {//全部行业
                    self.currentSelectData = filterData.filter_industry;
                    [self.viewManager.topView.secondBtn setTitle:self.currentIndustryStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentIndustryStr;
                }else if (button.tag == 100+3) {//全部阶段
                    self.currentSelectData = filterData.filter_round;
                    [self.viewManager.topView.thirdBtn setTitle:self.currentRoundStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentRoundStr;
                }else if (button.tag == 100+4) {//全部时间
                    self.currentSelectData = filterData.filter_time;
                    [self.viewManager.topView.fourBtn setTitle:self.currentTimeStr forState:UIControlStateNormal];
                    self.filterView.selectStr = self.currentTimeStr;
                }
                
                self.filterView.data = self.currentSelectData;
                
                [self.filterView showMenu:YES];
            }];
            
        };
    }
    return _viewManager;
}
-(CA_MDiscoverViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverViewModel new];
        _viewModel.data_type = @"investment";
        _viewModel.search_str = @"全部时间+全部阶段+全部行业+全部地区";
        _viewModel.search_type = @"time+round+industry+area";
        _viewModel.loadingView = self.viewManager.tableView;
        _viewModel.filter = NO;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore,BOOL isHasData) {
            CA_H_StrongSelf(self)
            
            self.viewModel.filter = NO;
            
            if (!isLoadMore) {
                [self.viewManager.tableView.mj_header endRefreshing];
            }

            if (!isHasData) {
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
