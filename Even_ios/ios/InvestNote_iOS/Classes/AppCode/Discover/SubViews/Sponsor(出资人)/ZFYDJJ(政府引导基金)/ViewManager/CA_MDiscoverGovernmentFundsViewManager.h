//
//  CA_MDiscoverGovernmentFundsViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverGovernmentFundsTopView;

@interface CA_MDiscoverGovernmentFundsViewManager : NSObject

@property (nonatomic,strong) CA_MDiscoverGovernmentFundsTopView *topView;

@property (nonatomic,strong) UITableView *tableView;

@end
