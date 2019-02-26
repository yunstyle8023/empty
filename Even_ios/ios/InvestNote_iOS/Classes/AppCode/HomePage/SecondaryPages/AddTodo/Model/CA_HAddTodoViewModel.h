//
//  CA_HAddTodoViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HTodoDetailModel.h"
#import "CA_HTodoModel.h"
#import "CA_HAddFileModel.h"

#import "CA_HUpdateFileManager.h"

@interface CA_HAddTodoViewModel : NSObject

#pragma mark --- 外部实现

@property (nonatomic, copy) void (^pushDetailBlock)(NSDictionary *dic, BOOL isEdit);

#pragma mark --- 内部实现

@property (nonatomic, copy) UIBarButtonItem *(^rightBarButtonItemBlock)(id target, SEL action);
@property (nonatomic, copy) UIView *(^titleViewBlock)(id delegate);
@property (nonatomic, copy) UITableView *(^tableViewBlock)(id delegate);

@property (nonatomic, strong) NSMutableArray *files;

// table
@property (nonatomic, copy) UITableViewCell *(^cellForRowBlock)(UITableView *tableView, NSIndexPath *indexPath);

@property (nonatomic, strong) CA_HTodoDetailModel *detailModel;
@property (nonatomic, strong) CA_HTodoModel *model;

@property (nonatomic, strong) CA_HUpdateFileManager *updateFileManager;
- (void)setAddFile:(CA_HAddFileModel *)addFile;

- (void)setTodoName:(NSString *)todoName;

@property (nonatomic, strong) NSArray *remindData;
@property (nonatomic, strong) NSArray *tagData;
- (void)loadParams:(void (^)(BOOL success))block;

@end
