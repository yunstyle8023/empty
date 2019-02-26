//
//  CA_HHomePageViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/21.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HHomePageViewController.h"

#import "CA_HNoteListTebleView.h"
#import "CA_HTodoListTableView.h"
#import "CA_HFileListTableView.h"

#import "CA_HScheduleListVC.h"

@interface CA_HHomePageViewModel : NSObject

@property (nonatomic, copy) CA_HHomePageViewController * (^getControllerBlock)(void);

// 跳转
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@property (nonatomic, strong) UIBarButtonItem * rightNavBarButton;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) CA_HNoteListTebleView * noteTableView;
@property (nonatomic, strong) CA_HTodoListTableView * todoTableView;
@property (nonatomic, strong) UIView * todoView;
@property (nonatomic, strong) CA_HFileListTableView * fileTableView;

- (void)hideMenu:(BOOL)animated;

- (void)reloadData;

// 日程
@property (nonatomic, strong) CA_HScheduleListVC *scheduleList;

@end
