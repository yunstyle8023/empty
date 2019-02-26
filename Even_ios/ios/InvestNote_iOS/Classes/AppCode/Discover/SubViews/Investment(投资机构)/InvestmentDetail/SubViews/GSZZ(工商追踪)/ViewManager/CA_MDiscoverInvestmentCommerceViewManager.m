//
//  CA_MDiscoverInvestmentCommerceViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentCommerceViewManager.h"
#import "CA_MDiscoverInvestmentCommerceCell.h"

@interface CA_MDiscoverInvestmentCommerceViewManager ()

@end

@implementation CA_MDiscoverInvestmentCommerceViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverInvestmentCommerceCell class] forCellReuseIdentifier:@"InvestmentCommerceCell"];
    }
    return _tableView;
}

@end
