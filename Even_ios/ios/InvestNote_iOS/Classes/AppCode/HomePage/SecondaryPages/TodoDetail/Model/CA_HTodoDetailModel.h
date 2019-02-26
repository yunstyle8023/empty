//
//  CA_HTodoDetailModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_HParticipantsModel.h"

@interface CA_HTodoDetailCommentModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *comment_id;//": 1,
@property (nonatomic, strong) CA_HParticipantsModel *creator;//": {
@property (nonatomic, copy) NSString *content;//": "评论内容",
@property (nonatomic, strong) NSNumber *ts_create;//": 13000,
@property (nonatomic, strong) NSNumber *ts_update;//": 14000,
@property (nonatomic, strong) NSArray *privilege;// 权限= ("delete"),
@property (nonatomic, strong) NSArray<CA_HParticipantsModel *> *notice_user_list;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end

@interface CA_HTodoDetailFileModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *file_id;//": 1,
@property (nonatomic, copy) NSString *file_url;//": "http://example.com/file.download",
@property (nonatomic, strong) NSNumber *file_size;//": 20111,     # 以byte 为单位
@property (nonatomic, copy) NSString *file_name;//": "文件名",
@property (nonatomic, strong) CA_HParticipantsModel *creator;//": {
@property (nonatomic, copy) NSString *file_icon;//": "http://example.com/icon.png",     # 文件图标
@property (nonatomic, strong) NSNumber *ts_create;//": 13000,
@property (nonatomic, strong) NSNumber *ts_update;//": 14000,

@end

@interface CA_HTodoDetailModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *todo_id;//": 1,
@property (nonatomic, copy) NSString *object_type;//": "project",       # person 个人待办, project 项目待办
@property (nonatomic, strong) NSNumber *object_id;//": 1,                 # 创建项目待办时, 传入项目id, 创建个人待办时, 传入0
@property (nonatomic, copy) NSString *object_name;//": "项目名称",     # 如果project_id 为0, 此处显示为个人项目
@property (nonatomic, copy) NSString *todo_name;//": "待办标题",
@property (nonatomic, strong) NSArray<NSString *> *privilege;//": ['comment', 'edit', 'delete'],     # 描述用户权限
@property (nonatomic, copy) NSString *status;//": "ready",
@property (nonatomic, strong) CA_HParticipantsModel *creator;//": {
@property (nonatomic, strong) NSArray<CA_HParticipantsModel *> *member_list;//":[
@property (nonatomic, strong) NSNumber *ts_finish;//": 9921,              # 截止时间的时间戳, 以utc 0 计算. 如果是0, 表明未设置.
@property (nonatomic, copy) NSString *todo_content;//": "todo 备注",    # todo 备注
@property (nonatomic, strong) NSArray<CA_HTodoDetailFileModel *> *file_list;//": [
@property (nonatomic, strong) NSMutableArray<CA_HTodoDetailCommentModel *> *comment_list;//": [
@property (nonatomic, strong) NSNumber *ts_create;


@property (nonatomic, strong) NSNumber *remind_time;//30,      # 提醒时间
@property (nonatomic, copy) NSString *remind_time_desc;//"30分钟",
@property (nonatomic, strong) NSNumber *tag_level;//3,      # 标签等级
@property (nonatomic, copy) NSString *tag_level_desc;//"紧急",
@property (nonatomic, copy) NSString *tag_level_color;//"",

@end
