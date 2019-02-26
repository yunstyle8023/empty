//
//  CA_MMessageDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MMessageBody : CA_HBaseModel
//@property (nonatomic,copy) NSString *check_detail;
@property (nonatomic,copy) NSString *object_type;
@property (nonatomic,strong) NSNumber *object_id;
@property (nonatomic,copy) NSString *related_type;
@property (nonatomic,strong) NSNumber *related_id;
@property (nonatomic,copy) NSString *notify_type;
@property (nonatomic,strong) NSNumber *notify_id;
@property (nonatomic,copy) NSString *file_path;
@property (nonatomic,copy) NSString *path_option;
@property (nonatomic,copy) NSString *file_url;
@property (nonatomic,copy) NSString *approval_result;
@property (nonatomic,copy) NSString *approval_reason;
@property (nonatomic,assign) BOOL check_detail;
@property (nonatomic,copy) NSString *color;
@property (nonatomic,copy) NSString *file_name;
//@property (nonatomic,copy) NSString *type;
//@property (nonatomic,strong) NSNumber *related_id;
//@property (nonatomic,copy) NSString *related_name;
@end

@interface CA_MModuleInfo : CA_HBaseModel
@property (nonatomic,copy) NSString *module_type;
@property (nonatomic,strong) NSNumber *module_id;
@property (nonatomic,copy) NSString *module_logo;
@property (nonatomic,copy) NSString *color;
@property (nonatomic,copy) NSString *module_name;
@end

@interface CA_MMessageCreator : CA_HBaseModel
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@end

@interface CA_MMessageDetailModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,strong) CA_MMessageCreator *creator;
@property (nonatomic,strong) NSNumber *ts_create;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) CA_MModuleInfo *module_info;
@property (nonatomic,strong) CA_MMessageBody *body;
@end
