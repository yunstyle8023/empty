//
//  CA_HMineModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HMineUserInfoModel : CA_HBaseModel

@property (nonatomic, copy) NSString *chinese_name;//": "tom",
@property (nonatomic, copy) NSString *avatar;//": "http://example.com/avatar.jpg",
@property (nonatomic, copy) NSString *avatar_color;//": "#ff0000",
@property (nonatomic, copy) NSString *role_name;//": "合伙人"        # 角色
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *extra;
@end

@interface CA_HMineCountModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *count;// = 0,
@property (nonatomic, copy) NSString *name;// = "新增项目"

@end

@interface CA_HMineModel : CA_HBaseModel

@property (nonatomic, strong) CA_HMineUserInfoModel *user_info;//":{
@property (nonatomic, strong) NSArray<CA_HMineCountModel *> *personal_count;//": {
@property (nonatomic, strong) NSNumber *approval_count;//" : 22,           # 我的审批
@property (nonatomic, strong) NSNumber *message_count;//": 1,              # 消息中心
@property (nonatomic, strong) NSNumber *ts_start;//": 32333 ,     # 统计开始时间戳
@property (nonatomic, strong) NSNumber *ts_end;//": 333333,       # 结束时间


@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy) void (^finishRequestBlock)(BOOL success);
- (void)loadData;

@end
