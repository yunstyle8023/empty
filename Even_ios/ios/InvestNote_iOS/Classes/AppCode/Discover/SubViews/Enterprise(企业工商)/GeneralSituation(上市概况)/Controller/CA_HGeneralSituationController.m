//
//  CA_HGeneralSituationController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HGeneralSituationController.h"

#import "CA_HGeneralSituationViewManager.h"

#import "CA_HBaseTableCell.h"
#import "CA_HGeneralSituationHeader.h"

@interface CA_HGeneralSituationController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HGeneralSituationViewManager *viewManager;

@end

@implementation CA_HGeneralSituationController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HGeneralSituationModelManager *)modelManager {
    if (!_modelManager) {
        CA_HGeneralSituationModelManager *modelManager = [CA_HGeneralSituationModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.loadDetailBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            if (success) {
                if (!self.viewManager.tableView.superview) {
                    [self upView];
                }
            }
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _modelManager;
}

- (CA_HGeneralSituationViewManager *)viewManager {
    if (!_viewManager) {
        CA_HGeneralSituationViewManager *viewManager = [CA_HGeneralSituationViewManager new];
        _viewManager = viewManager;
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
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
    
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadDetail];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelManager.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelManager.data[section][@"data_list"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataArray = self.modelManager.data[indexPath.section][@"data_list"][indexPath.row];
    NSString *classStr = dataArray.count>1?@"CA_HGeneralSituationDoubleCell":@"CA_HGeneralSituationSingleCell";
    return [tableView cellHeightForIndexPath:indexPath model:dataArray keyPath:@"model" cellClass:NSClassFromString(classStr) contentViewWidth:tableView.width];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65*CA_H_RATIO_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CA_HGeneralSituationHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.label.text = self.modelManager.data[section][@"title"];
    header.line.hidden = (section == 0);
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *dataArray = self.modelManager.data[indexPath.section][@"data_list"][indexPath.row];
    
    NSString *identifier = dataArray.count>1?@"cell2":@"cell1";
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.model = dataArray;
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}


@end
