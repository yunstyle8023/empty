//
//  CA_HFinancialDataViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HFinancialDataCell.h"

@interface CA_HFinancialDataViewManager : NSObject

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, copy) void (^chooseBlock)(NSInteger item);


@property (nonatomic, strong) UITableView *tableView;

@end
