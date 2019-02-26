//
//  CA_MPersonDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MPersonModel.h"


@interface CA_MJob_experience: CA_HBaseModel
@property (nonatomic,strong) NSNumber *company_id;
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,strong) NSNumber *ts_jod_start;
@property (nonatomic,strong) NSNumber *ts_jod_end;
@property (nonatomic,strong) NSNumber *experience_id;
@property (nonatomic,copy) NSString *jod_position;
@property (nonatomic,copy) NSString *job_content;
@property (nonatomic,copy) NSString *job_achievement;
@end

@interface CA_MContact_project: CA_HBaseModel
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_slogan;
@property (nonatomic,copy) NSString *job_position;
@property (nonatomic,strong) NSNumber *contact_id;
@end

@interface CA_MHuman_detail : CA_HBaseModel
@property (nonatomic,strong) NSNumber *human_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *avatar_color;
@property (nonatomic,strong) NSNumber *ts_born;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *wechat;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,strong) NSNumber *age;
@property (nonatomic,strong) NSArray<CA_MPersonTagModel*> *tag_data;
@end

@interface CA_MPersonDetailModel : CA_HBaseModel
@property (nonatomic,strong) CA_MHuman_detail *human_detail;
@property (nonatomic,strong) NSArray<CA_MContact_project*> *contact_project;
@property (nonatomic,strong) NSArray<CA_MJob_experience*> *job_experience;
@end
