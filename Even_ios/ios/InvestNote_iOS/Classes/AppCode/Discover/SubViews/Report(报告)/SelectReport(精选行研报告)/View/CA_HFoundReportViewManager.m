//
//  CA_HFoundReportViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundReportViewManager.h"

@interface CA_HFoundReportViewManager ()

@end

@implementation CA_HFoundReportViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.rowHeight = 65*CA_H_RATIO_WIDTH;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerClass:NSClassFromString(@"CA_HFoundReportCell") forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)searchView:(id)target action:(SEL)action {
    self.tableView.tableHeaderView = [CA_HFoundFactoryPattern searchHeaderView:target action:action];
}

#pragma mark --- Delegate

@end
