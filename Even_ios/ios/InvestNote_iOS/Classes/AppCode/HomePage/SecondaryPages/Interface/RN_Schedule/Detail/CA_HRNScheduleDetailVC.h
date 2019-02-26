//
//  CA_HRNScheduleDetailVC.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HScheduleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HRNScheduleDetailVC : CA_HBaseViewController

@property (nonatomic, strong) CA_HScheduleListModel *model;
@property (nonatomic, strong) NSNumber *scheduleId;

@end

NS_ASSUME_NONNULL_END
