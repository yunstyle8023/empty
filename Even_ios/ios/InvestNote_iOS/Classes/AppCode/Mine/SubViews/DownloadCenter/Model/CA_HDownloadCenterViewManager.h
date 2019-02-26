//
//  CA_HDownloadCenterViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HDownloadCenterCell.h"
#import "CA_HEditMenuView.h"

#import "CA_HDownloadReportCell.h" // 下载报告

@interface CA_HDownloadCenterViewManager : NSObject

@property (nonatomic, copy) void (^onSearchBlock)(void);

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CA_HEditMenuView *menuView;

@end
