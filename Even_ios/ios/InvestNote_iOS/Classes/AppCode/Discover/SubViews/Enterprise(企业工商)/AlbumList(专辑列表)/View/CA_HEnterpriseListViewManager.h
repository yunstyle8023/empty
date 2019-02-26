//
//  CA_HEnterpriseListViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBaseTableCell.h"

@interface CA_HEnterpriseListViewManager : NSObject

@property (nonatomic, strong) UITableView *tableView;

- (void)searchView:(id)target action:(SEL)action;

@property (nonatomic, strong) UITableViewHeaderFooterView *headerView;

@end
