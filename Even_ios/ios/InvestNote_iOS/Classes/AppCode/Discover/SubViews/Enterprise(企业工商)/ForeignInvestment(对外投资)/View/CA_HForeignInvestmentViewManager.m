//
//  CA_HForeignInvestmentViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HForeignInvestmentViewManager.h"

#import "CA_HNullView.h"

@interface CA_HForeignInvestmentViewManager ()

@end

@implementation CA_HForeignInvestmentViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
        tableView.tableHeaderView = view;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        
        tableView.backgroundView = [CA_HNullView newTitle:@"暂无对外投资信息" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_search"];
        
        [tableView registerClass:NSClassFromString(@"CA_HForeignInvestmentCell") forCellReuseIdentifier:@"cell"];
        
        tableView.rowHeight = 190*CA_H_RATIO_WIDTH;
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
