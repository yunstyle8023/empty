//
//  CA_MNewProjectSingleViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MEmptyView;

@interface CA_MNewProjectSingleViewManager : NSObject

@property (nonatomic,strong) CA_MEmptyView *emptyView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *rightBarButtonItems;

@property (nonatomic,copy) dispatch_block_t searchBlock;

@property (nonatomic,copy) dispatch_block_t selectBlock;

@end
