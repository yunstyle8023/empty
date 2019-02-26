//
//  CA_MDiscoverViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverViewManager.h"
#import "CA_MDiscoverTitleView.h"
#import "CA_MDiscoverTableHeaderView.h"
#import "CA_MDiscoverCell.h"

@interface CA_MDiscoverViewManager ()
@end

@implementation CA_MDiscoverViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[CA_MDiscoverCell class] forCellReuseIdentifier:@"DiscoverCell"];
    }
    return _tableView;
}

-(UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [UIView new];
        UILabel *titleLb = [UILabel new];
        [titleLb configText:@"最新融资"
                  textColor:CA_H_4BLACKCOLOR
                       font:16];
        [_sectionHeaderView addSubview:titleLb];
        titleLb.sd_layout
        .topSpaceToView(_sectionHeaderView, 7*2*CA_H_RATIO_WIDTH)
        .leftSpaceToView(_sectionHeaderView, 20)
        .widthIs(CA_H_SCREEN_WIDTH)
        .autoHeightRatio(0);
    }
    return _sectionHeaderView;
}

-(CA_MDiscoverTableHeaderView *)headerView{
    if (!_headerView) {
        CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 102*2*CA_H_RATIO_WIDTH);
        _headerView = [[CA_MDiscoverTableHeaderView alloc] initWithFrame:rect];
        CA_H_WeakSelf(self);
        _headerView.pushBlock = ^(NSIndexPath *indexPath, CA_MModuleModel *model) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(indexPath, model);
            }
        };
    }
    return _headerView;
}

-(CA_MDiscoverTitleView *)titleView{
    if (!_titleView) {
        CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH-40, 15*2*CA_H_RATIO_WIDTH);
        _titleView = [[CA_MDiscoverTitleView alloc] initWithFrame:rect];
    }
    return _titleView;
}

@end
