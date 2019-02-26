//
//  CA_HScheduleListVC.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleListVC : ASViewController

@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@end

NS_ASSUME_NONNULL_END
