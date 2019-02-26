//
//  CA_MDiscoverProjectViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectViewManager.h"
#import "CA_HNoteListTebleView.h"
#import "CA_MDiscoverProjectCell.h"

@interface CA_MDiscoverProjectViewManager ()
@property (nonatomic,strong) CA_HNoteListTebleView *listTableView;
@end

@implementation CA_MDiscoverProjectViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        _tableView.tableHeaderView = self.listTableView.headerView;
        [_tableView registerClass:[CA_MDiscoverProjectCell class] forCellReuseIdentifier:@"DiscoverProjectCell"];
    }
    return _tableView;
}

-(CA_HNoteListTebleView *)listTableView{
    if (!_listTableView) {
        _listTableView = [CA_HNoteListTebleView new];
        CA_H_WeakSelf(self);
        _listTableView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (self.jumpBlock) {
                self.jumpBlock();
            }
        };
    }
    return _listTableView;
}

@end
