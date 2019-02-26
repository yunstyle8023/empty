
//
//  CA_MDiscoverInvestmentVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentVC.h"
#import "CA_MDiscoverInvestmentViewManager.h"
#import "CA_MDiscoverInvestmentViewModel.h"
#import "CA_MDiscoverInvestmentModel.h"
#import "CA_MDiscoverInvestmentCell.h"
#import "CA_HFoundSearchController.h"
#import "CA_HFoundFactoryPattern.h"
#import "CA_MDiscoverInvestmentDetailVC.h"

#import "CA_MDiscoverInvestmentTopView.h"
#import "CA_HFilterMenu.h"

@interface CA_MDiscoverInvestmentVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MDiscoverInvestmentViewManager *viewManager;
@property (nonatomic,strong) CA_MDiscoverInvestmentViewModel *viewModel;

@property (nonatomic, strong) CA_HFilterMenu *filterView;
@property (nonatomic,assign) NSInteger currentSelectButton;//当前选中的哪个按钮
@property (nonatomic,copy) NSString *currentAreaStr;
@property (nonatomic,copy) NSString *currentTypeStr;
@property (nonatomic, strong) NSArray *currentSelectData;
@end

@implementation CA_MDiscoverInvestmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
    self.currentAreaStr = @"全部地区";
    self.currentTypeStr = @"全部类型";
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
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
    self.viewManager.tableView.scrollEnabled = self.viewModel.investmentModel.data_list.count>0;
    self.viewManager.tableView.mj_footer.hidden = self.viewModel.investmentModel.data_list.count==0;
    return self.viewModel.investmentModel.data_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverInvestmentCell *investmentCell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCell"];
    investmentCell.model = self.viewModel.investmentModel.data_list[indexPath.row];
    [investmentCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return investmentCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CA_MDiscoverInvestmentDetailVC *investmentVC = [CA_MDiscoverInvestmentDetailVC new];
    CA_MDiscoverInvestmentData_list *model = self.viewModel.investmentModel.data_list[indexPath.row];
    investmentVC.data_id = model.data_id;
    [self.navigationController pushViewController:investmentVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.investmentModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverInvestmentCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
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
                if (self.currentSelectButton == 100+1) {//第一个按钮 所在地区
                    self.viewManager.topView.firstBtn.selected = NO;
                }else if (self.currentSelectButton == 100+2) {//第二个按钮 资本类型
                    self.viewManager.topView.secondBtn.selected = NO;
                }
            }else {

                if (self.currentSelectButton == 100+1) {//第一个按钮 所在地区
                    
                    self.currentAreaStr = [self.currentSelectData objectAtIndex:item];
                    
                    [self.viewManager.topView.firstBtn setTitle:self.currentAreaStr forState:UIControlStateNormal];
                    self.viewManager.topView.firstBtn.selected = NO;
                    
                    self.filterView.selectStr = self.currentAreaStr;
                }else if (self.currentSelectButton == 100+2) {//第二个按钮 资本类型
                    
                    self.currentTypeStr = [self.currentSelectData objectAtIndex:item];
                    
                    [self.viewManager.topView.secondBtn setTitle:self.currentTypeStr forState:UIControlStateNormal];
                    self.viewManager.topView.secondBtn.selected = NO;
                    
                    self.filterView.selectStr = self.currentTypeStr;
                }
                
                
                self.viewModel.search_str = [NSString stringWithFormat:@"%@+%@+",
                                             [self.currentAreaStr isEqualToString:@"全部地区"]?@"all":self.currentAreaStr,[self.currentTypeStr isEqualToString:@"全部类型"]?@"all":self.currentTypeStr];
                
                self.viewModel.refreshBlock();
            }

        };
        
    }
    return _filterView;
}

-(CA_MDiscoverInvestmentViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverInvestmentViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.filter = NO;
            self.viewModel.refreshBlock();
        }];
        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.loadMoreBlock();
        }];
        _viewManager.jumpBlock = ^{
            CA_H_StrongSelf(self)
            CA_HFoundSearchController *searchVC = [CA_HFoundSearchController new];
            searchVC.modelManager.type = CA_HFoundSearchTypeGp;
            [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:searchVC] animated:YES completion:^{
                
            }];
        };
        _viewManager.topView.didSelected = ^(UIButton *button) {
            CA_H_StrongSelf(self)
            
            if (!button.isSelected) {
                [self.filterView hideMenu:YES];
                return ;
            }

            [self.viewModel loadFilterData:^(CA_MDiscoverInvestmentFilterData *filterData) {
                CA_H_StrongSelf(self)

                self.currentSelectButton = button.tag;

                if (button.tag == 100+1) {//第一个按钮 全部地区
                    self.currentSelectData = filterData.filter_area;
                    self.viewManager.topView.firstBtn.selected = YES;
                    self.viewManager.topView.secondBtn.selected = NO;
                    [self.viewManager.topView.firstBtn setTitle:self.currentAreaStr forState:UIControlStateNormal];

                    self.filterView.selectStr = self.currentAreaStr;
                }else if (button.tag == 100+2) {//第二个按钮 全部类型
                    self.currentSelectData = filterData.filter_captial_type;
                    self.viewManager.topView.firstBtn.selected = NO;
                    self.viewManager.topView.secondBtn.selected = YES;
                    [self.viewManager.topView.secondBtn setTitle:self.currentTypeStr forState:UIControlStateNormal];

                    self.filterView.selectStr = self.currentTypeStr;
                }

                self.filterView.data = self.currentSelectData;

                [self.filterView showMenu:YES];
            }];
            
        };
    }
    return _viewManager;
}

-(CA_MDiscoverInvestmentViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MDiscoverInvestmentViewModel new];
        _viewModel.data_type = @"gp";
        _viewModel.search_str = @"all+all+";
        _viewModel.search_type = @"area+captial_type+str";
        _viewModel.filter = YES;
        _viewModel.loadingView = self.viewManager.tableView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isLoadMore,BOOL isHasData) {
            CA_H_StrongSelf(self)
            
            self.viewManager.tableView.backgroundView.hidden = self.viewModel.investmentModel.data_list.count;
            
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
