//
//  CA_HDIYHeader.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDIYHeader.h"

@implementation CA_HDIYHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    CA_HDIYHeader *mj_header = [super headerWithRefreshingBlock:refreshingBlock];
    
    mj_header.lastUpdatedTimeLabel.textColor = CA_H_9GRAYCOLOR;
//    mj_header.lastUpdatedTimeLabel.font = CA_H_FONT_PFSC_Regular(12);
    
    mj_header.stateLabel.textColor = CA_H_TINTCOLOR;
//    mj_header.stateLabel.font = CA_H_FONT_PFSC_Regular(13);
    [mj_header setTitle:CA_H_LAN(@"继续下拉刷新") forState:MJRefreshStateIdle];
    [mj_header setTitle:CA_H_LAN(@"正在刷新数据中...") forState:MJRefreshStateRefreshing];
    
//    mj_header.ignoredScrollViewContentInsetTop = -2*CA_H_RATIO_WIDTH;
    return mj_header;
}

@end
