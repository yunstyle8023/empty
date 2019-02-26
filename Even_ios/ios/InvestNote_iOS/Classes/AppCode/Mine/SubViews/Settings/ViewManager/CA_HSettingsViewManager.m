//
//  CA_HSettingsViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSettingsViewManager.h"

#import "CA_HSettingsCell.h"

@interface CA_HSettingsViewManager ()

@end

@implementation CA_HSettingsViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.bounces = NO;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 53*CA_H_RATIO_WIDTH, 0);
        tableView.tableHeaderView.height = 5*CA_H_RATIO_WIDTH;
        tableView.tableFooterView.height = 75*CA_H_RATIO_WIDTH;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 53*CA_H_RATIO_WIDTH;
        
        [tableView registerClass:[CA_HSettingsCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton new];
        _button = button;
        
        [button setTitleColor:CA_H_5AREDCOLOR forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"退出登录") forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(18);
        
        [self.tableView.tableFooterView addSubview:button];
        button.sd_layout
        .widthIs(150*CA_H_RATIO_WIDTH)
        .heightIs(40*CA_H_RATIO_WIDTH)
        .centerXEqualToView(button.superview)
        .bottomEqualToView(button.superview);
        
    }
    return _button;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
