//
//  CA_HShowDate.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HShowDate.h"

@implementation CA_HShowDate

+ (NSString *)showDate:(NSDate *)date {
    
    NSString *format = @"";
    
    if (date.isToday) {
        if (fabs(date.timeIntervalSinceNow) < 60) {
            return @"刚刚";
        } else if (fabs(date.timeIntervalSinceNow) < 60*60) {
            return [NSString stringWithFormat:@"%.2ld分钟前", (long)(fabs(date.timeIntervalSinceNow)/60)];
        } else {
            format = @"HH:mm";
        }
    } else if (date.isYesterday) {
        format = @"昨天 HH:mm";
    } else {
        if (date.year == [NSDate date].year) {
            format = @"MM.dd HH:mm";
        } else {
            format = @"yyyy.MM.dd HH:mm";
        }
    }
    
    return [date stringWithFormat:format];
}

+ (NSString *)showDateWithoutTime:(NSDate *)date {
    
    NSString *format = @"";
    
    if (date.isToday) {
        return @"今天";
    } else if (date.isYesterday) {
        return @"昨天";
    } else {
        if (date.year == [NSDate date].year) {
            format = @"MM.dd";
        } else {
            format = @"yyyy.MM.dd";
        }
    }
    
    return [date stringWithFormat:format];
}

@end
