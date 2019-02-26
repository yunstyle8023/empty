//
//  CA_MDiscoverInvestmentViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverInvestmentTopView;

@interface CA_MDiscoverInvestmentViewManager : NSObject

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CA_MDiscoverInvestmentTopView *topView;
@property (nonatomic,copy) dispatch_block_t jumpBlock;
@end
