//
//  CA_HChooseFolderViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBrowseFoldersModel.h"

@interface CA_HChooseFolderViewModel : NSObject

@property (nonatomic, copy) CA_HBaseViewController * (^getControllerBlock)(void);
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr,  CA_HBrowseFoldersModel *parentModel);
@property (nonatomic, copy) void (^chooseBlock)(CA_HBrowseFoldersModel *parentModel);

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSArray * titles;

- (UIView *)fileListView:(NSInteger)item;

@property (nonatomic, strong) CA_HBrowseFoldersModel *parentModel;

@property (nonatomic, copy) void (^finishRequestBlock)(BOOL success, BOOL noMore);
@property (nonatomic, copy) void (^loadDataBlock)(void);

@end
