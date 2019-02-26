//
//  CA_MMyApproveDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MMyApproveModel.h"

@interface CA_MResult_detail : CA_HBaseModel
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *result_commit;
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *user_phone;
@property (nonatomic,copy) NSString *user_role;
@property (nonatomic,copy) NSString *result_english_status;
@property (nonatomic,copy) NSString *result_status_color;
@end

@interface CA_MApproval_member : CA_HBaseModel
@property (nonatomic,copy) NSString *user_avatar;
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_phone;
@property (nonatomic,copy) NSString *user_role;
@end


@interface CA_MMyApproveDetailModel : CA_HBaseModel
@property (nonatomic,copy) NSString *approval_conclude_sub_title;
@property (nonatomic,copy) NSString *approval_conclude_title;
@property (nonatomic,assign) BOOL need_approval;
@property (nonatomic,strong) CA_MApprovalCreateUser *approval_create_user;
@property (nonatomic,strong) NSNumber *approval_id;
@property (nonatomic,strong) NSArray<CA_MApproval_member*> *approval_member;
@property (nonatomic,strong) NSNumber *approval_project_id;
@property (nonatomic,strong) CA_MApprovalProjectInfo *approval_project_info;
@property (nonatomic,copy) NSString *approval_reason;
@property (nonatomic,strong) NSArray *approval_standard;
@property (nonatomic,copy) NSString *approval_status;
@property (nonatomic,copy) NSString *approval_title;
@property (nonatomic,strong) NSArray<CA_MResult_detail*> *result_detail;
@property (nonatomic,strong) NSNumber *ts_approval;
@property (nonatomic,copy) NSString *approval_english_status;
@property (nonatomic,copy) NSString *approval_status_color;
@end
