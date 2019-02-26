//
//  CA_MDiscoverSponsorItemInvestViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemInvestViewManager.h"
#import "CA_MDiscoverSponsorItemInvestCell.h"

@implementation CA_MDiscoverSponsorItemInvestViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        //        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        [_tableView registerClass:[CA_MDiscoverSponsorItemInvestCell class] forCellReuseIdentifier:@"ItemInvestCell"];
    }
    return _tableView;
}

@end
