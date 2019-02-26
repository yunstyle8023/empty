//
//  UITableView+CA_HTableView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "UITableView+CA_HTableView.h"

@implementation UITableView (CA_HTableView)

/**
 自定义创建方法
 
 @return tableView
 */
+ (instancetype)newTableViewPlain{
    UITableView * tableView = [[self alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView upTableConfig];
    return tableView;
}
+ (instancetype)newTableViewGrouped{
    UITableView * tableView = [[self alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView upTableConfig];
    return tableView;
}



/**
    更新配置
 */
- (void)upTableConfig{
    self.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView = [self ca_noHeaderFooterView];
    self.tableFooterView = [self ca_noHeaderFooterView];
    self.sectionHeaderHeight = 0;
    self.sectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


/**
    消除HeaderFooter高度

 @return 最小view
 */
- (UIView *)ca_noHeaderFooterView{
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, CA_H_RATIO_WIDTH);
    return view;
}

@end
