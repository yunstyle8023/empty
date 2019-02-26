
//
//  CA_MDiscoverSponsorItemDetailViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemProjectViewManager.h"
#import "CA_MDiscoverSponsorItemProjectCell.h"

@implementation CA_MDiscoverSponsorItemProjectViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        [_tableView registerClass:[CA_MDiscoverSponsorItemProjectCell class] forCellReuseIdentifier:@"ItemProjectCell"];
    }
    return _tableView;
}

@end
