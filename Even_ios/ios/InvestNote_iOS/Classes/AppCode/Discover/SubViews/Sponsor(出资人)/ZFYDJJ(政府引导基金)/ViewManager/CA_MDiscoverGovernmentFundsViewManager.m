//
//  CA_MDiscoverGovernmentFundsViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverGovernmentFundsViewManager.h"
#import "CA_MDiscoverGovernmentFundsTopView.h"
#import "CA_MDiscoverSponsorCell.h"
#import "CA_HNullView.h"

@implementation CA_MDiscoverGovernmentFundsViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [CA_HNullView newTitle:@"暂无融资事件"
                                               buttonTitle:nil
                                                       top:136*CA_H_RATIO_WIDTH
                                                  onButton:nil
                                                 imageName:@"empty_search"];
        _tableView.backgroundView.hidden = YES;
        [_tableView registerClass:[CA_MDiscoverSponsorCell class] forCellReuseIdentifier:@"SponsorCell"];
    }
    return _tableView;
}

-(CA_MDiscoverGovernmentFundsTopView *)topView{
    if (!_topView) {
        _topView = [CA_MDiscoverGovernmentFundsTopView new];
    }
    return _topView;
}

@end








