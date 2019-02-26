//
//  CA_HGeneralSituationViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HGeneralSituationViewManager.h"

@interface CA_HGeneralSituationViewManager ()

@end

@implementation CA_HGeneralSituationViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        
        [tableView registerClass:NSClassFromString(@"CA_HGeneralSituationSingleCell") forCellReuseIdentifier:@"cell1"];
        [tableView registerClass:NSClassFromString(@"CA_HGeneralSituationDoubleCell") forCellReuseIdentifier:@"cell2"];
        [tableView registerClass:NSClassFromString(@"CA_HGeneralSituationHeader") forHeaderFooterViewReuseIdentifier:@"header"];
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
