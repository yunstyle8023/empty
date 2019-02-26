//
//  CA_MDiscoverViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverTitleView,CA_MDiscoverTableHeaderView,CA_MModuleModel;

@interface CA_MDiscoverViewManager : NSObject
@property (nonatomic,strong) CA_MDiscoverTitleView *titleView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CA_MDiscoverTableHeaderView *headerView;
@property (nonatomic,strong) UIView *sectionHeaderView;
@property (nonatomic,copy) void(^pushBlock)(NSIndexPath *indexPath,CA_MModuleModel *model);
@end
