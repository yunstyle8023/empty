//
//  CA_MDiscoverProjectViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MDiscoverProjectViewManager : NSObject
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) dispatch_block_t jumpBlock;
@end
