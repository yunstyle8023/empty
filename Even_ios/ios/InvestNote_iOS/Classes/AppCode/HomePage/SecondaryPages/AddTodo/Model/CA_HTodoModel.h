//
//  CA_HTodoModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HTodoModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *object_id;//": 1,            # 创建项目待办时, 传入项目id, 创建个人待办时, 传入0
@property (nonatomic, copy) NSString *todo_name;//": "待办标题",
@property (nonatomic, strong) NSArray<NSNumber *> *member_id_list;//": [1, 2, 3],    # 参与人的user id
@property (nonatomic, strong) NSNumber *ts_finish;//": 9921,              # 截止时间的时间戳, 以utc 0 计算. 如果是0, 表明未设置.
@property (nonatomic, copy) NSString *todo_content;//": "todo 备注",    # todo 备注
@property (nonatomic, strong) NSArray<NSNumber *> *file_id_list;//": [3, 4, 5],      # 文件 id list

@property (nonatomic, strong) NSNumber *tag_level;//3,# 等级标签
@property (nonatomic, copy) NSString *tag_level_desc;
@property (nonatomic, strong) NSNumber *remind_time;//30,# 提前提醒时间
@property (nonatomic, copy) NSString *remind_time_desc;


@property (nonatomic, strong) NSDate *finishDate;
@property (nonatomic, copy) NSString *objectName;
@property (nonatomic, strong) NSArray *peoples;

@end
