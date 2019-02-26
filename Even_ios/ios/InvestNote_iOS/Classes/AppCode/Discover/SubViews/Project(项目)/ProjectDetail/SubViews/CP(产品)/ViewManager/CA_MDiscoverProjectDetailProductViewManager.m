//
//  CA_MDiscoverProjectDetailProductViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailProductViewManager.h"
#import "CA_MDiscoverProjectDetailProductCell.h"

@implementation CA_MDiscoverProjectDetailProductViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverProjectDetailProductCell class] forCellReuseIdentifier:@"ProductCell"];
    }
    return _tableView;
}

@end
