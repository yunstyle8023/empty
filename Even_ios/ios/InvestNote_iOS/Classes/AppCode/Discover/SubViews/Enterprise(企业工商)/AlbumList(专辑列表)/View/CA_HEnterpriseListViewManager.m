//
//  CA_HEnterpriseListViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HEnterpriseListViewManager.h"

@interface CA_HEnterpriseListViewManager ()

@end

@implementation CA_HEnterpriseListViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.rowHeight = 97*CA_H_RATIO_WIDTH;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerClass:NSClassFromString(@"CA_HEnterpriseAlbumCell") forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UITableViewHeaderFooterView *)headerView {
    if (!_headerView) {
        UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        _headerView = headerView;
        
        UILabel *label = [UILabel new];
        label.font = CA_H_FONT_PFSC_Regular(16);
        label.textColor = CA_H_4BLACKCOLOR;
        label.numberOfLines = 1;
        label.text = @"企业专辑";
        [label sizeToFit];
        
        [headerView addSubview:label];
        label.sd_layout
        .topSpaceToView(headerView, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(headerView, 20*CA_H_RATIO_WIDTH)
        .minWidthIs(64*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
    }
    return _headerView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)searchView:(id)target action:(SEL)action {
    self.tableView.tableHeaderView = [CA_HFoundFactoryPattern searchHeaderView:target action:action];
}

#pragma mark --- Delegate

@end
