//
//  CA_HScheduleListMM.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HScheduleListModel.h"
#import "CA_HParticipantsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleListMM : NSObject
    
@property (nonatomic, strong) NSMutableArray *data;


@property (nonatomic, strong) NSNumber * _Nullable start_time;//': ('开始时间', 'optional int'),  # utc时间戳(秒)
@property (nonatomic, strong) NSNumber * _Nullable end_time;//': ('结束时间', 'optional int'),  # utc时间戳(秒)
@property (nonatomic, assign) NSUInteger page_num;//': ('页码', 'optional int'),
@property (nonatomic, assign) NSUInteger page_size;//': ('页容量', 'optional int'),

- (void)reloadMore:(void(^)(void))callBack;

@property (nonatomic, strong) NSNumber *total_count;

@property (nonatomic, strong) NSArray *user_ids;
@property (nonatomic, copy) NSString *user_name;

- (void)reloadFilter:(void(^)(void))callBack;

@end

NS_ASSUME_NONNULL_END
