//
//  CA_HScheduleTool.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2019/1/7.
//  Copyright © 2019年 韩云智. All rights reserved.
//

#import "CA_HScheduleTool.h"

#import <EventKit/EventKit.h>

@implementation CA_HScheduleTool

+ (void)synchronousEventCalendar {
    if (!CA_H_MANAGER.shouldEventCalendar) {
        return;
    }
    [CA_HNetManager postUrlStr:CA_H_Api_ListMyValidSchedule parameters:nil callBack:^(CA_HNetModel *netModel) {
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]]) {
                    [self synchronousEventCalendarWithArray:netModel.data[@"data_list"]];
                }
            }
        }
    } progress:nil];
}

+ (void)synchronousEventCalendarWithArray:(NSArray *)array {
    NSDictionary *oldDic = [CA_H_UserDefaults objectForKey:CA_H_SchemesEventCalenda];
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:oldDic.allKeys];
    for (NSDictionary *dic in array) {
        CA_HScheduleListModel *model = [CA_HScheduleListModel modelWithDictionary:dic];
        NSString *key = model.id.stringValue;
        if ([allKeys containsObject:key]) {
            [allKeys removeObject:key];
            [self editEventCalendarWithModel:model];
        } else {
            [self createEventCalendarWithModel:model];
        }
    }
    EKEventStore *store = [[EKEventStore alloc] init];
    for (NSString *k in allKeys) {
        NSString *identifier = [oldDic objectForKey:k];
        EKEvent *event = [store eventWithIdentifier:identifier];
        if ([event.endDate compare:[NSDate date]] == NSOrderedAscending) {
            [self deleteEventCalendarWithId:k.numberValue];
        }
    }
}

+ (void)deleteEventCalendarWithId:(NSNumber *)scheduleId {
    if (!CA_H_MANAGER.shouldEventCalendar) {
        return;
    }
    if (![scheduleId isKindOfClass:[NSNumber class]]) {
        return;
    }
    NSDictionary *oldDic = [CA_H_UserDefaults objectForKey:CA_H_SchemesEventCalenda];
    NSString *identifier = [oldDic objectForKey:scheduleId.stringValue];
    if (identifier) {
        EKEventStore *store = [[EKEventStore alloc] init];
        EKEvent *event = [store eventWithIdentifier:identifier];
        NSError *error;
        [store removeEvent:event span:EKSpanFutureEvents error:&error];
        if (!error) {
            NSLog(@"删除成功");
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
            [dic removeObjectForKey:scheduleId.stringValue];
            [CA_H_UserDefaults setObject:dic forKey:CA_H_SchemesEventCalenda];
            [CA_H_UserDefaults synchronize];
        } else {
            NSLog(@"删除失败：%@",error);
        }
    }
}

+ (void)editEventCalendarWithModel:(CA_HScheduleListModel *)model {
    if (!CA_H_MANAGER.shouldEventCalendar) {
        return;
    }
    if (!model) {
        return;
    }
    
    NSDictionary *oldDic = [CA_H_UserDefaults objectForKey:CA_H_SchemesEventCalenda];
    NSString *identifier = [oldDic objectForKey:model.id.stringValue];
    if (!identifier) {
        [self createEventCalendarWithModel:model];
        return;
    }
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event = [store eventWithIdentifier:identifier];
    if (!event) {
        [self createEventCalendarWithModel:model];
        return;
    }
    
    event.title = model.title;
    event.calendar = [store defaultCalendarForNewEvents];
    event.startDate = [NSDate dateWithTimeIntervalSince1970:model.start_time.doubleValue];
    event.endDate = [NSDate dateWithTimeIntervalSince1970:model.end_time.doubleValue];
    event.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Schedule", CA_H_UrlSchemes]];
    event.location = model.address;
    event.notes = model.content;
    NSArray *array = [NSArray arrayWithArray:event.alarms];
    for (EKAlarm *alarm in array) {
        [event removeAlarm:alarm];
    }
    double time = model.remind_time?model.remind_time.doubleValue:0;
    if (time > 0) {
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*time]];
    }
    NSError *error;
    [store saveEvent:event span:EKSpanFutureEvents commit:YES  error:&error];
    if (!error) {
        NSLog(@"编辑成功！");
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
        [dic setObject:event.eventIdentifier forKey:model.id.stringValue];
        [CA_H_UserDefaults setObject:dic forKey:CA_H_SchemesEventCalenda];
        [CA_H_UserDefaults synchronize];
    }else{
        NSLog(@"编辑失败：%@",error);
    }
}

+ (void)createEventCalendarWithModel:(CA_HScheduleListModel *)model {
    if (!CA_H_MANAGER.shouldEventCalendar) {
        return;
    }
    if (!model) {
        return;
    }
    EKEventStore *store = [[EKEventStore alloc] init];
    CA_H_WeakSelf(self);
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CA_H_StrongSelf(self);
                if (error)
                {
                    //@"添加失败，请稍后重试";
                }else if (!granted){
                    //@"不允许使用日历,请在设置中允许此App使用日历";
                }else{
                    EKEvent *event  = [EKEvent eventWithEventStore:store];
                    event.title = model.title;
                    event.calendar = [store defaultCalendarForNewEvents];
                    event.startDate = [NSDate dateWithTimeIntervalSince1970:model.start_time.doubleValue];
                    event.endDate = [NSDate dateWithTimeIntervalSince1970:model.end_time.doubleValue];;
                    event.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Schedule", CA_H_UrlSchemes]];
                    event.location = model.address;
                    event.notes = model.content;
                    double time = model.remind_time?model.remind_time.doubleValue:0;
                    if (time > 0) {
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*time]];
                    }
                    NSError *error;
                    [store saveEvent:event span:EKSpanFutureEvents commit:YES  error:&error];
                    if (!error) {
                        NSLog(@"添加成功！");
                        NSDictionary *oldDic = [CA_H_UserDefaults objectForKey:CA_H_SchemesEventCalenda];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
                        [dic setObject:event.eventIdentifier forKey:model.id.stringValue];
                        [CA_H_UserDefaults setObject:dic forKey:CA_H_SchemesEventCalenda];
                        [CA_H_UserDefaults synchronize];
                    }else{
                        NSLog(@"添加失败：%@",error);
                    }
                }
            });
        }];
    }
}

@end
