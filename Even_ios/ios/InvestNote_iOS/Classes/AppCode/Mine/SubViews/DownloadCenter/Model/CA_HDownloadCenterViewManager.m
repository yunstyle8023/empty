//
//  CA_HDownloadCenterViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadCenterViewManager.h"

#import "CA_HNullView.h"

@interface CA_HDownloadCenterViewManager ()

@end

@implementation CA_HDownloadCenterViewManager

#pragma mark --- Action

- (void)onSearchButton:(UIButton *)sender {
    if (self.onSearchBlock) {
        self.onSearchBlock();
    }
}

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.backgroundView = [CA_HNullView newTitle:@"当前没有任何下载"
                                              buttonTitle:nil
                                                      top:140*CA_H_RATIO_WIDTH
                                                 onButton:nil
                                                imageName:@"empty_download"];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = [self headerView];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.rowHeight = 65*CA_H_RATIO_WIDTH;
        
        [tableView registerClass:[CA_HDownloadCenterCell class] forCellReuseIdentifier:@"cell"];
        [tableView registerClass:[CA_HDownloadReportCell class] forCellReuseIdentifier:@"reportCell"];
    }
    return _tableView;
}

- (CA_HEditMenuView *)menuView {
    if (!_menuView) {
        CA_HEditMenuView *menuView = [CA_HEditMenuView new];
        _menuView = menuView;
        menuView.frame = CA_H_MANAGER.mainWindow.bounds;
    }
    return _menuView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)headerView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 50*CA_H_RATIO_WIDTH);
    
    CA_HSetButton *searchButton = [CA_HSetButton new];
    
    searchButton.backgroundColor = CA_H_F8COLOR;
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
    searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(onSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:searchButton];
    searchButton.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
    
    return view;
}

#pragma mark --- Delegate

@end
