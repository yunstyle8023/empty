//
//  CA_MNewSearchProjectViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MSettingHeaderView;
@class CA_MCustomTextFieldView;
@class CA_MProjectNotFoundView;
@class CA_MNoSearchDataView;


@interface CA_MNewSearchProjectViewManager : NSObject

@property (nonatomic,strong) UIBarButtonItem *leftBarButton;

@property (nonatomic,copy) void(^leftBarButtonBlock)(UIButton *sender);

@property(nonatomic,strong)UIView *txtFieldBgView;

@property(nonatomic,strong) CA_MCustomTextFieldView *txtFieldView;

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) CA_MSettingHeaderView *headerView;

@property (nonatomic,strong) CA_MNoSearchDataView *noSearchDataView;

@property (nonatomic,strong) CA_MProjectNotFoundView *notFoundView;

@end
