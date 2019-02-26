//
//  CA_HMineViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineViewManager.h"

#import "CA_HMineInfoCell.h"
#import "CA_HMineCountCell.h"
#import "CA_HMineCell.h"

@interface CA_HMineViewManager ()

@end

@implementation CA_HMineViewManager

#pragma mark --- Action

#pragma mark -CA_HMineViewController-- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
//        tableView.bounces = NO;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 53*CA_H_RATIO_WIDTH, 0);

        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 33*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
        tableView.tableHeaderView = headerView;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerClass:[CA_HMineInfoCell class] forCellReuseIdentifier:@"info"];
        [tableView registerClass:[CA_HMineCountCell class] forCellReuseIdentifier:@"count"];
        [tableView registerClass:[CA_HMineCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
