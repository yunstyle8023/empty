//
//  CA_MMyApproveModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MApprovalProjectInfo : CA_HBaseModel
@property (nonatomic,strong) NSNumber *project_id;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_color;
@end

@interface CA_MApprovalCreateUser : CA_HBaseModel
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *user_role;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *extra;
@end

@interface CA_MMyApproveModel : CA_HBaseModel
@property (nonatomic,strong) CA_MApprovalCreateUser *approval_create_user;
@property (nonatomic,strong) CA_MApprovalProjectInfo *approval_project_info;
@property (nonatomic,strong) NSNumber *approval_id;
@property (nonatomic,copy) NSString *approval_reason;
@property (nonatomic,copy) NSString *approval_standard;
@property (nonatomic,copy) NSString *approval_status;
@property (nonatomic,copy) NSString *approval_title;
@property (nonatomic,copy) NSString *approval_status_color;
@property (nonatomic,copy) NSString *approval_english_status;
@end
