//
//  CA_HScheduleListModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleListModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *id;// 2,
@property (nonatomic, copy) NSString *title;//
@property (nonatomic, copy) NSString *address;//
@property (nonatomic, strong) NSNumber *start_time;// 1530934433,  # utc时间戳(秒)
@property (nonatomic, strong) NSNumber *end_time;// 1530935433,  # utc时间戳(秒)
@property (nonatomic, strong) NSNumber *remind_time;// 30,
@property (nonatomic, copy) NSString *remind_time_desc;//
@property (nonatomic, strong) NSNumber *privacy_typ;// 1,
@property (nonatomic, copy) NSString *privacy_typ_desc;//
@property (nonatomic, copy) NSString *content;//
@property (nonatomic, strong) NSArray *user_list;// []

@property (nonatomic, copy) NSString *start_time_show;//
@property (nonatomic, copy) NSString *end_time_show;//


@property (nonatomic, strong) NSNumber *editable;// 0,  # 当前用户是否可以编辑，0为不可编辑，1为可以编辑
@property (nonatomic, strong) NSNumber *creator_id;// 124,
@property (nonatomic, strong) NSNumber *dt_create;// 1541993369,
@property (nonatomic, strong) NSNumber *dt_update;// 1541993369,
@property (nonatomic, strong) NSArray *logs;// []
@property (nonatomic, strong) NSNumber *is_participate;//': 1, # 1为当前用户参与了此日程；0为当前用户未参与此日程

@property (nonatomic, assign) BOOL isNew;

@end

NS_ASSUME_NONNULL_END
