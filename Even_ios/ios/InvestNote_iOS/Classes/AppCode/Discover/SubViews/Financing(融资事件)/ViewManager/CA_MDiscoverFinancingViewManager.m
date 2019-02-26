
//
//  CA_MDiscoverFinancingViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverFinancingViewManager.h"
#import "CA_MDiscoverProjectCell.h"
#import "CA_MDiscoverInvestmentTopView.h"
#import "CA_HNullView.h"

@implementation CA_MDiscoverFinancingViewManager

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        //        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        [_tableView registerClass:[CA_MDiscoverProjectCell class] forCellReuseIdentifier:@"DiscoverProjectCell"];
        _tableView.backgroundView = [CA_HNullView newTitle:@"暂无融资事件" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_search"];
        _tableView.backgroundView.hidden = YES;
    }
    return _tableView;
}

-(CA_MDiscoverInvestmentTopView *)topView{
    if (!_topView) {
        _topView = [[CA_MDiscoverInvestmentTopView alloc] initWithAreaBtnTitle:@"全部地区"
                                                                  typeBtnTitle:@"全部行业"
                                                                 roundBtnTitle:@"全部阶段"
                                                                  timeBtnTitle:@"全部时间"];
    }
    return _topView;
}

@end
