//
//  CA_HScheduleScreeningVC.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleScreeningVC : CA_HBaseViewController

- (instancetype)initWithObjectString:(NSString *)objectString userIds:(NSArray *)userIds;
- (void)setStart:(NSNumber *)start end:(NSNumber *)end;

@end

NS_ASSUME_NONNULL_END
