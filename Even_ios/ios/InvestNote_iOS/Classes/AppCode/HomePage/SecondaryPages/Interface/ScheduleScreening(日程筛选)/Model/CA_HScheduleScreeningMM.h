//
//  CA_HScheduleScreeningMM.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HParticipantsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleScreeningMM : NSObject

@property (nonatomic, strong) NSString *objectString;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSArray *userIds;
@property (nonatomic, strong) NSMutableArray *data;
- (void)postlistCompanyUser:(void(^)(CA_HNetModel * netModel))callBack;

@end

NS_ASSUME_NONNULL_END
