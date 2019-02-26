//
//  CA_MDiscoverInvestmentMemberListViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentMemberListViewManager.h"
#import "CA_MDiscoverProjectDetailCorePersonCell.h"

@implementation CA_MDiscoverInvestmentMemberListViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverProjectDetailCorePersonCell class] forCellReuseIdentifier:@"CorePersonCell"];
    }
    return _tableView;
}

@end
