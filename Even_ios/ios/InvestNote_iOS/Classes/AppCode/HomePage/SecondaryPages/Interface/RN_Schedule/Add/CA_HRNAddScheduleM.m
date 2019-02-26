//
//  CA_HRNAddScheduleM.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRNAddScheduleM.h"


@interface CA_HRNAddScheduleM ()

@end

@implementation CA_HRNAddScheduleM
    

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotificateRN:) name:@"getRNState" object:nil];
        
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"getRNState"];
}
- (void)receivePushNotificateRN:(NSNotification *)notification {
//    NSString *eventName = notification.userInfo[@"name"];
    [self sendEventWithName:@"getRNState" body:nil];
}
RCT_EXPORT_METHOD(getRNState:(NSDictionary *)state)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getSaveData" object:nil userInfo:state];
}


RCT_EXPORT_METHOD(changeItem:(RCTResponseSenderBlock)callBack)
{
    _callBack = callBack;
}

RCT_EXPORT_METHOD(onItemIndex:(nonnull NSNumber *)index info:(NSDictionary *)info)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToEdit" object: self userInfo:@{@"index":(index?index:@(-1)), @"info":(info?info:@{})}];
}

//RCT_EXPORT_METHOD(changeSwitch:(BOOL)isSwitch)
//{
//
//}

@end
