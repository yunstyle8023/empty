//
//  CA_HTodoListTableView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CA_HListTodoModel.h"

@interface CA_HTodoListTableView : UITableView

// 跳转
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@property (nonatomic, strong) CA_HListTodoModel *finishedModel;
@property (nonatomic, strong) CA_HListTodoModel *unfinishedModel;

//@property (nonatomic, strong) NSMutableArray * data;
@property (nonatomic, strong) UIView * header;

+ (instancetype)newWithProjectId:(NSNumber *)projectId;

@end
