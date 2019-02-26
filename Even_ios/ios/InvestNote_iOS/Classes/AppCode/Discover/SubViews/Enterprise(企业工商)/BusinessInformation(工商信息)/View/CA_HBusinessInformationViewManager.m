//
//  CA_HBusinessInformationViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationViewManager.h"

@interface CA_HBusinessInformationViewManager () 

@end

@implementation CA_HBusinessInformationViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight+60*CA_H_RATIO_WIDTH, 0);
        
        [tableView registerClass:NSClassFromString(@"CA_HBusinessInformationBasicCell") forCellReuseIdentifier:@"cell0"];
        [tableView registerClass:NSClassFromString(@"CA_HBusinessInformationShareholdersCell") forCellReuseIdentifier:@"cell1"];
        [tableView registerClass:NSClassFromString(@"CA_HBusinessInformationPersonnelCell") forCellReuseIdentifier:@"cell2"];
        [tableView registerClass:NSClassFromString(@"CA_HBusinessInformationChangeCell") forCellReuseIdentifier:@"cell3"];
        [tableView registerClass:NSClassFromString(@"CA_HBusinessInformationBranchCell") forCellReuseIdentifier:@"cell4"];
        
        
        [tableView registerClass:NSClassFromString(@"CA_HGeneralSituationHeader") forHeaderFooterViewReuseIdentifier:@"header"];
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
