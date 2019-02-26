//
//  CA_HScheduleListMM.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListMM.h"

@implementation CA_HScheduleListMM

#pragma mark --- Action

#pragma mark --- Lazy

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)reloadFilter:(void(^)(void))callBack {
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_ScheduleFilter parameters:nil callBack:^(CA_HNetModel *netModel) {
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                CA_H_StrongSelf(self);
                self.user_ids = netModel.data[@"user_ids"];
                self.user_name = netModel.data[@"first_user_name"];
            }
        }
        if (callBack) callBack();
    } progress:nil];
}

- (void)reloadMore:(void(^)(void))callBack {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (self.start_time) [parameters setValue:self.start_time forKey:@"start_time"];
    if (self.end_time) [parameters setValue:self.end_time forKey:@"end_time"];
    if (self.user_ids) [parameters setValue:self.user_ids forKey:@"user_ids"];
    [parameters setValue:@(self.page_num+1) forKey:@"page_num"];
    [parameters setValue:@(self.page_size>0?self.page_size:30) forKey:@"page_size"];
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_ListSchedule parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                CA_H_StrongSelf(self);
                self.page_num = [netModel.data[@"page_num"] integerValue];
                self.total_count = netModel.data[@"total_count"];
                
                if (self.page_num == 1) {
                    [self.data removeAllObjects];
                }
                for (NSDictionary *dic in netModel.data[@"data_list"]) {
                    [self.data addObject:[CA_HScheduleListModel modelWithDictionary:dic]];
                }
            }
        }
        if (callBack) callBack();
    } progress:nil];
}

#pragma mark --- Delegate

@end
