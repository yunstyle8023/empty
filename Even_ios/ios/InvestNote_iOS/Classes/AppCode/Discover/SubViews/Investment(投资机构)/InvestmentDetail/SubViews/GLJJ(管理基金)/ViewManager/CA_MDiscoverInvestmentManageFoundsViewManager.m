
//
//  CA_MDiscoverInvestmentManageFoundsViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsViewManager.h"
#import "CA_MDiscoverInvestmentManageFoundsCell.h"
#import "CA_MDiscoverInvestmentFoundsCell.h"
#import "CA_MDiscoverInvestmentFoundsProjectCell.h"

@implementation CA_MDiscoverInvestmentManageFoundsViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverInvestmentManageFoundsCell class] forCellReuseIdentifier:@"InvestmentManageFoundsCell"];
        [_tableView registerClass:[CA_MDiscoverInvestmentFoundsCell class] forCellReuseIdentifier:@"InvestmentFoundsCell"];
        [_tableView registerClass:[CA_MDiscoverInvestmentFoundsProjectCell class] forCellReuseIdentifier:@"InvestmentFoundsProjectCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
