//
//  CA_MDiscoverInvestmentViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentViewManager.h"
#import "CA_HNoteListTebleView.h"
#import "CA_MDiscoverInvestmentCell.h"
#import "CA_MDiscoverInvestmentTopView.h"
#import "CA_HNullView.h"

@interface CA_MDiscoverInvestmentViewManager ()
@property (nonatomic,strong) CA_HNoteListTebleView *listTableView;
@end

@implementation CA_MDiscoverInvestmentViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        _tableView.rowHeight = 58*2*CA_H_RATIO_WIDTH;
        _tableView.tableHeaderView = self.listTableView.headerView;
        [_tableView registerClass:[CA_MDiscoverInvestmentCell class] forCellReuseIdentifier:@"InvestmentCell"];
        _tableView.backgroundView = [CA_HNullView newTitle:@"暂无投资机构" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_search"];
        _tableView.backgroundView.hidden = YES;
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

-(CA_MDiscoverInvestmentTopView *)topView{
    if (!_topView) {
        _topView = [[CA_MDiscoverInvestmentTopView alloc] initWithAreaBtnTitle:@"全部地区" typeBtnTitle:@"全部类型"];
    }
    return _topView;
}

@end
