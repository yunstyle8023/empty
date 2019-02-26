//
//  CA_MProjectTraceDynamicViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceDynamicViewManager.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MProjectInvestDynamicCell.h"

@implementation CA_MProjectTraceDynamicViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverProjectDetailNewsCell class] forCellReuseIdentifier:@"NewsCell"];
        [_tableView registerClass:[CA_MProjectInvestDynamicCell class] forCellReuseIdentifier:@"DynamicCell"];
    }
    return _tableView;
}

@end
