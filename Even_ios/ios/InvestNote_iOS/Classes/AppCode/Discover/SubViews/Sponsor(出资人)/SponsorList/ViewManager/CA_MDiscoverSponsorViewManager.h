//
//  CA_MDiscoverSponsorViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverSponsorHeaderView;
@class CA_MDiscoverSponsorChangeView;

@interface CA_MDiscoverSponsorViewManager : NSObject

@property (nonatomic,strong) CA_MDiscoverSponsorHeaderView *headView;

@property (nonatomic,strong) CA_MDiscoverSponsorChangeView *changeView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) dispatch_block_t changeBlock;

@end
