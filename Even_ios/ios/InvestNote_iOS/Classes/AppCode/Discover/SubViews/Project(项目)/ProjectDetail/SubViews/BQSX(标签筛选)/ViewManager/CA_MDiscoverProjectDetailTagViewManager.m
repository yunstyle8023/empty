
//
//  CA_MDiscoverProjectDetailTagViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailTagViewManager.h"
#import "CA_MDiscoverProjectDetailTagCell.h"

@implementation CA_MDiscoverProjectDetailTagViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverProjectDetailTagCell class] forCellReuseIdentifier:@"TagCell"];
    }
    return _tableView;
}

@end
