//
//  CA_HChooseParticipantsViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HTodoNetModel.h"
#import "CA_HParticipantsModel.h"

@interface CA_HChooseParticipantsViewModel : NSObject

#pragma mark --- 外部实现

@property (nonatomic, copy) void (^backBlock)(NSArray *people);

#pragma mark --- 内部实现

@property (nonatomic, copy) UIBarButtonItem *(^leftBarButtonItemBlock)(id target, SEL action);
@property (nonatomic, copy) UIBarButtonItem *(^rightBarButtonItemBlock)(id target, SEL action);

@property (nonatomic, copy) UITableView *(^tableViewBlock)(id delegate);


@property (nonatomic, copy) void (^onButtonBlock)(BOOL isDone);

// table
@property (nonatomic, copy) UITableViewCell *(^cellForRowBlock)(UITableView *tableView, NSIndexPath *indexPath);

@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, copy) void (^changeRightBarBlock)(UIView *barView);


@property (nonatomic, strong) NSArray *selectId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSMutableArray<CA_HParticipantsModel *> *data;

@end
