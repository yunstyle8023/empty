//
//  CA_MProjectDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MInvest_history :CA_HBaseModel
@property (nonatomic,copy) NSString *invest_money;
@property (nonatomic,strong) NSNumber *ts_invest;
@property (nonatomic,copy) NSString *investor;
@property (nonatomic,copy) NSString *invest_stage;

@property (nonatomic,copy) NSString *invest_date;
@end

@interface CA_MHeader_info :CA_HBaseModel
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,strong) NSArray *area;
@property (nonatomic,strong) NSNumber *invest_stage_id;
@property (nonatomic,strong) NSNumber *parent_category_id;
@property (nonatomic,strong) NSNumber *child_category_id;
@property (nonatomic,copy) NSString *child_category_name;
@property (nonatomic,copy) NSString *project_color;
@property (nonatomic,copy) NSString *invest_stage_name;
@property (nonatomic,copy) NSString *parent_category_name;
@property (nonatomic,copy) NSString *project_logo;
@end

@interface CA_MProcedure_status :CA_HBaseModel
@property (nonatomic,strong) NSNumber *procedure_status_id;
@property (nonatomic,copy) NSString *procedure_status_name;
@end

@interface CA_MValuation :CA_HBaseModel
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *currency_sym;
@property (nonatomic,copy) NSString *currency_cn;
@property (nonatomic,copy) NSString *currency_en;
@property (nonatomic,strong) NSNumber *currency_id;
@end

@interface CA_MSource :CA_HBaseModel
@property (nonatomic,strong) NSNumber *source_id;
@property (nonatomic,copy) NSString *source_name;
@end

@interface CA_MValuation_method :CA_HBaseModel
@property (nonatomic,strong) NSNumber *valuation_method_id;
@property (nonatomic,copy) NSString *valuation_method_name;
@end

@interface CA_MBasic_info :CA_HBaseModel
@property (nonatomic,strong) CA_MValuation_method *valuation_method;
@property (nonatomic,strong) CA_MSource *source;
@property (nonatomic,strong) CA_MValuation *valuation;
@property (nonatomic,strong) CA_MProcedure_status *procedure_status;
@property (nonatomic,copy) NSString *contact;
@property (nonatomic,copy) NSString *source_comment;
@end

@interface CA_MCompany_info :CA_HBaseModel
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *company_website;
@property (nonatomic,strong) NSNumber *found_time;
@property (nonatomic,copy) NSString *register_capital;
@property (nonatomic,copy) NSString *company_wechat;
@property (nonatomic,copy) NSString *legal_person;
@end

@interface CA_MTag_list :CA_HBaseModel
@property (nonatomic,copy) NSString *tag_name;
@property (nonatomic,strong) NSNumber *tag_id;
@end

@interface CA_MProject_info :CA_HBaseModel
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,copy) NSString *invest_highlight;
@property (nonatomic,copy) NSString *invest_risk;
@property (nonatomic,copy) NSString *slogan;
@property (nonatomic,strong) NSArray<CA_MTag_list*> *tag_list;
@end

@interface CA_MProject_person :CA_HBaseModel
@property (nonatomic,strong) NSNumber *hr_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *position;
@property (nonatomic,copy) NSString *avatar;

//
@property (nonatomic,strong) NSNumber *file_id;
@property (nonatomic,strong) NSArray *file_path;
@end

@interface CA_MProjectDetailModel : NSObject
@property (nonatomic,strong) NSArray<CA_MProject_person*> *project_person;
@property (nonatomic,strong) NSNumber *file_id;
@property (nonatomic,strong) CA_MProject_info *project_info;
@property (nonatomic,strong) CA_MCompany_info *company_info;
@property (nonatomic,strong) NSArray *file_name;
@property (nonatomic,strong) CA_MBasic_info *basic_info;
@property (nonatomic,strong) CA_MHeader_info *header_info;
@property (nonatomic,strong) NSNumber *project_id;
@property (nonatomic,strong) NSArray<CA_MInvest_history*> *invest_history;

@property (nonatomic,strong) NSNumber *member_type_id;
@property (nonatomic,copy) NSString *member_type_name;
@end

