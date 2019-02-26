//
//  CA_MDiscoverFinancingViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverInvestmentTopView;

@interface CA_MDiscoverFinancingViewManager : NSObject
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CA_MDiscoverInvestmentTopView *topView;
@end
