//
//  CA_MDiscoverRelatedNewsViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedNewsViewManager.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"

@implementation CA_MDiscoverRelatedNewsViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverProjectDetailNewsCell class] forCellReuseIdentifier:@"NewsCell"];
    }
    return _tableView;
}

@end
