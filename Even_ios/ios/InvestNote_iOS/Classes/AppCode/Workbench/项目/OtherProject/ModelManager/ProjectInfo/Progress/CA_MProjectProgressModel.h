//
//  CA_MProjectProgressModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
@class CA_MApproval_user;

@interface CA_MApproval_result :CA_HBaseModel
@property (nonatomic,strong) NSNumber *ts_create;
@property (nonatomic,strong) NSNumber *ts_update;
@property (nonatomic,strong) CA_MApproval_user *approval_user;
@property (nonatomic,copy) NSString *approval_result;
@property (nonatomic,copy) NSString *approval_comment;

@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,strong) NSNumber *project_procedure_id;
@end

@interface CA_MApproval_user :CA_HBaseModel
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *avatar_color;
@end

@interface CA_MCreator :CA_HBaseModel
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *avatar_color;
@end

@interface CA_MProcedure_logModel :CA_HBaseModel
@property (nonatomic,strong) NSNumber *procedure_log_id;
@property (nonatomic,copy) NSString *procedure_log_title;
@property (nonatomic,copy) NSString *procedure_status;
@property (nonatomic,copy) NSString *procedure_comment;
@property (nonatomic,strong) NSNumber *ts_create;
@property (nonatomic,strong) CA_MCreator *creator;
@property (nonatomic,copy) NSString *sub_title;
@property (nonatomic,strong) NSArray<CA_MApproval_user*> *approval_user_list;
@property (nonatomic,strong) NSArray<CA_MApproval_result*> *approval_result_list;
@end

@interface CA_Mprocedure_viewModel :CA_HBaseModel
@property (nonatomic,strong) NSNumber *procedure_id;
@property (nonatomic,copy) NSString *procedure_name;
@property (nonatomic,copy) NSString *procedure_status;
@property (nonatomic,copy) NSString *procedure_color;
@end

@interface CA_MProjectProgressModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *current_procedure_id;
@property (nonatomic,strong) NSNumber *current_node_id;
@property (nonatomic,copy) NSString *current_status;
@property (nonatomic,strong) NSArray<CA_Mprocedure_viewModel*> *procedure_view;
@property (nonatomic,strong) NSArray<CA_MProcedure_logModel*> *procedure_log;
@end
