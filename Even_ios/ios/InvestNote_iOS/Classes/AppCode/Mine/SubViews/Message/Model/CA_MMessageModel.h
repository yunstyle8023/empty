//
//  CA_MMessageModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

//typedef enum : NSUInteger {
//    Project,//项目通知
//    Comment,//评论通知
//    Approval,//审批通知
//    System//系统通知
//} MessageType;

@interface CA_MMessage : CA_HBaseModel
@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber *ts_update;
//
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *projectName;
@property (nonatomic,copy) NSString *type;
@end

@interface CA_MMessageModel : CA_HBaseModel
@property (nonatomic,strong) CA_MMessage *system;
@property (nonatomic,strong) CA_MMessage *approval;
@property (nonatomic,strong) CA_MMessage *comment;
@property (nonatomic,strong) CA_MMessage *project;
@end
