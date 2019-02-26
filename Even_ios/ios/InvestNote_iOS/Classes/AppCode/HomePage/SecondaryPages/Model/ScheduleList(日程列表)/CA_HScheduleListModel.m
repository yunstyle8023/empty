//
//  CA_HScheduleListModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListModel.h"

@implementation CA_HScheduleListModel

- (void)setStart_time:(NSNumber *)start_time {
    _start_time = start_time;
    
    if (start_time) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:start_time.longValue];
        _start_time_show = [date stringWithFormat:@"MM-dd HH:mm"];
    }
}

- (void)setEnd_time:(NSNumber *)end_time {
    _end_time = end_time;
    
    if (end_time) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:end_time.longValue];
        _end_time_show = [date stringWithFormat:@"MM-dd HH:mm"];
    }
}

@end
