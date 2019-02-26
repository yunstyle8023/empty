
//
//  CA_MDiscoverRelatedProjecViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedProjecViewManager.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"

@implementation CA_MDiscoverRelatedProjecViewManager
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        [_tableView registerClass:[CA_MDiscoverProjectDetailRelatedProductCell class] forCellReuseIdentifier:@"RelatedProductCell"];
    }
    return _tableView;
}

@end
