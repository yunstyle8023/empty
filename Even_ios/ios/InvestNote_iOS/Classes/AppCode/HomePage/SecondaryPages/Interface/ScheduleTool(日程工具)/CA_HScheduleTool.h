//
//  CA_HScheduleTool.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2019/1/7.
//  Copyright © 2019年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HScheduleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleTool : NSObject

+ (void)createEventCalendarWithModel:(CA_HScheduleListModel *)model;
+ (void)deleteEventCalendarWithId:(NSNumber *)scheduleId;
+ (void)editEventCalendarWithModel:(CA_HScheduleListModel *)model;
+ (void)synchronousEventCalendar;

@end

NS_ASSUME_NONNULL_END
