//
//  CA_HShareToFriendViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HBrowseFoldersModel.h"

@interface CA_HShareToFriendViewModel : NSObject

#pragma mark --- 外部实现

@property (nonatomic, copy) void (^shareBlock)(BOOL success);
@property (nonatomic, assign) double progress;
@property (nonatomic, strong) CA_HBrowseFoldersModel *model;

#pragma mark --- 内部实现

@property (nonatomic, copy) UIView *(^shareViewBlock)(id target, SEL action);

@end
