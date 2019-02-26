//
//  CA_HFinancialDataController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFinancialDataController.h"

#import "CA_HFinancialDataViewManager.h"

#import "CA_HFilterMenu.h"

@interface CA_HFinancialDataController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HFinancialDataViewManager *viewManager;

@property (nonatomic, strong) CA_HFilterMenu *menuView;

@end

@implementation CA_HFinancialDataController

#pragma mark --- Action

- (void)onTopButton:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [self.menuView hideMenu:YES];
    } else {
        sender.selected = YES;
        self.menuView.selectStr = sender.titleLabel.text;
        self.menuView.data = self.modelManager.dateList;
        [self.menuView showMenu:YES];
    }
}

#pragma mark --- Lazy

- (CA_HFinancialDataModelManager *)modelManager {
    if (!_modelManager) {
        CA_HFinancialDataModelManager *modelManager = [CA_HFinancialDataModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.loadDetailBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            if (success) {
                if (!self.viewManager.tableView.superview) {
                    [self upView];
                }
            }
            [self.viewManager.tableView reloadData];
            [self.viewManager.tableView setContentOffset:CGPointZero];
            [self.viewManager.topButton setTitle:self.modelManager.financialDate forState:UIControlStateNormal];
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _modelManager;
}

- (CA_HFinancialDataViewManager *)viewManager {
    if (!_viewManager) {
        CA_HFinancialDataViewManager *viewManager = [CA_HFinancialDataViewManager new];
        _viewManager = viewManager;
        
        CA_H_WeakSelf(self);
        viewManager.chooseBlock = ^(NSInteger item) {
            CA_H_StrongSelf(self);
            self.modelManager.item = item;
            if (self.modelManager.data) {
                [self.viewManager.tableView reloadData];
                [self.viewManager.tableView setContentOffset:CGPointZero];
            } else {
                [CA_HProgressHUD showHud:self.view text:nil];
                [self.modelManager loadDetail:self.modelManager.financialDate];
            }
        };
        
        [viewManager.topButton addTarget:self action:@selector(onTopButton:) forControlEvents:UIControlEventTouchUpInside];
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
    }
    return _viewManager;
}

- (CA_HFilterMenu *)menuView {
    if (!_menuView) {
        CA_HFilterMenu *menuView = [CA_HFilterMenu new];
        _menuView = menuView;
        
        menuView.frame = CGRectMake(0, 37*CA_H_RATIO_WIDTH, self.view.width, self.view.height-37*CA_H_RATIO_WIDTH);
        [self.view addSubview:menuView];
        
        menuView.maxHeight = 295*CA_H_RATIO_WIDTH;
        
        CA_H_WeakSelf(self);
        menuView.clickBlock = ^(NSInteger item) {
            [self.menuView hideMenu:YES];
            self.viewManager.topButton.selected = NO;
            if (item<0) {
                
            } else {
                NSString *financialDate = self.modelManager.dateList[item];
                [self.viewManager.topButton setTitle:financialDate forState:UIControlStateNormal];
                [CA_HProgressHUD showHud:self.view text:nil];
                [self.modelManager loadDetail:financialDate];
            }
        };
    }
    return _menuView;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadDetail:self.modelManager.financialDate];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.buttonView];
    self.viewManager.buttonView.sd_layout
    .heightIs(36*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.view, 52*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.view, 20*CA_H_RATIO_WIDTH);
    self.viewManager.buttonView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(98*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    self.viewManager.topView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 37*CA_H_RATIO_WIDTH);
    [self.view addSubview:self.viewManager.topView];
    [CA_HFoundFactoryPattern showShadowWithView:self.viewManager.topView];
}

#pragma mark --- Table


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelManager.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.modelManager.data[indexPath.row] keyPath:@"model" cellClass:[CA_HFinancialDataCell class] contentViewWidth:tableView.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HFinancialDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.topLine.hidden = (indexPath.row!=0);
    cell.model = self.modelManager.data[indexPath.row];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

@end
