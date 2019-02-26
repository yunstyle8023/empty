//
//  CA_HBrowseFoldersViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/26.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HFileListTableView.h"

// 上传文件
#import "CA_HUpdateFileManager.h"

@interface CA_HBrowseFoldersViewModel : NSObject

@property (nonatomic, copy) CA_HBaseViewController * (^getControllerBlock)(void);
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);
@property (nonatomic, copy) void (^onSearchBlock)(void);

@property (nonatomic, strong) CA_HListFileModel *listFileModel;

@property (nonatomic, strong) UIBarButtonItem * rightNavBarButton;
@property (nonatomic, strong) CA_HBrowseFoldersModel *model;
@property (nonatomic, strong) CA_HFileListTableView * tableView;

@property (nonatomic, strong) CA_HUpdateFileManager *updateFileManager;

- (void)addBarButton:(UIBarButtonItem *)sender;

@end
