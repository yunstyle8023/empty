//
//  CA_HListTodoModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_HParticipantsModel.h"

@interface CA_HListTodoContentModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *todo_id;//": 1,
@property (nonatomic, copy) NSString *todo_name;//": "todo 标题",
@property (nonatomic, copy) NSString *status;//": "finish",
@property (nonatomic, strong) NSNumber *ts_finish;//": 13000,             # 时间戳 UTC 0, 0 表示未设置截止时间
@property (nonatomic, strong) CA_HParticipantsModel *creator;//": {
@property (nonatomic, strong) NSArray<CA_HParticipantsModel *> *member_list;//":[
@property (nonatomic, copy) NSString *object_type;// = "project",
@property (nonatomic, copy) NSString *object_name;// = "滴滴打人",
@property (nonatomic, strong) NSNumber *object_id;// = 1,

//@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, strong) NSNumber *tag_level;//1,
@property (nonatomic, copy) NSString *tag_level_desc;//"普通",
@property (nonatomic, copy) NSString *tag_level_color;//"",

@end

@interface CA_HListTodoModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *page_num;//": 2,
@property (nonatomic, strong) NSNumber *page_size;//": 50,
@property (nonatomic, strong) NSNumber *total_count;//": 200,
@property (nonatomic, strong) NSArray *data_list;//":

@property (nonatomic, copy) NSString *objectType;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSMutableArray<CA_HListTodoContentModel *> *data;
@property (nonatomic, copy) void (^finishRequestBlock)(CA_H_RefreshType type);
@property (nonatomic, copy) void (^loadMoreBlock)(void);

@property (nonatomic, copy) void (^showFirstBlock)(void);

@end
