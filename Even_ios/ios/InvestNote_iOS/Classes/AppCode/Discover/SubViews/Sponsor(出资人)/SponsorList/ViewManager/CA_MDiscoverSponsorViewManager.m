//
//  CA_MDiscoverSponsorViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorViewManager.h"
#import "CA_MDiscoverSponsorHeaderView.h"
#import "CA_MDiscoverSponsorCell.h"
#import "CA_MDiscoverSponsorChangeView.h"

@interface CA_MDiscoverSponsorViewManager ()
@property (nonatomic,strong) CA_HNoteListTebleView *listTableView;
@end

@implementation CA_MDiscoverSponsorViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 36*2*CA_H_RATIO_WIDTH)];
        [_tableView registerClass:[CA_MDiscoverSponsorCell class] forCellReuseIdentifier:@"SponsorCell"];
    }
    return _tableView;
}

-(CA_MDiscoverSponsorHeaderView *)headView{
    if (!_headView) {
        _headView = [[CA_MDiscoverSponsorHeaderView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 50*2*CA_H_RATIO_WIDTH-3.f*CA_H_RATIO_WIDTH)];
    }
    return _headView;
}

-(CA_MDiscoverSponsorChangeView *)changeView{
    if (!_changeView) {
        CGRect rect = CGRectMake(CA_H_SCREEN_WIDTH/2 - 62*CA_H_RATIO_WIDTH, CA_H_SCREEN_HEIGHT - (kDevice_Is_iPhoneX?88:64) - (17+17)*2*CA_H_RATIO_WIDTH , 55*2*CA_H_RATIO_WIDTH, 17*2*CA_H_RATIO_WIDTH);
        _changeView = [[CA_MDiscoverSponsorChangeView alloc] initWithFrame:rect];
        _changeView.hidden = YES;
        CA_H_WeakSelf(self)
        _changeView.pushBlock = ^{
            CA_H_StrongSelf(self)
            if (self.changeBlock) {
                self.changeBlock();
            }
        };
    }
    return _changeView;
}

@end
