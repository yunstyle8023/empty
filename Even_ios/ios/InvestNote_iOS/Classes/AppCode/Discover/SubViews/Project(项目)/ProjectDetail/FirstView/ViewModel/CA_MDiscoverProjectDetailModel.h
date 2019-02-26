//
//  CA_MDiscoverProjectDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"


@interface CA_MRequestModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,strong) NSNumber *project_id;
@end

@interface CA_MDiscoverProjectDetailRequestModel : CA_HBaseModel
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *project_id;
@end

@interface CA_MDiscoverNews_list : CA_HBaseModel
@property (nonatomic,copy) NSString *news_title;
@property (nonatomic,strong) NSNumber *news_publish_date;
@property (nonatomic,copy) NSString *news_source;
@property (nonatomic,copy) NSString *news_url;

@end

@interface CA_MDiscoverNews_data : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSArray<CA_MDiscoverNews_list*> *news_list;
@end

@interface CA_MDiscoverCompatible_project_list : CA_HBaseModel
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_last_round;
@property (nonatomic,strong) NSNumber *project_start_date;
@property (nonatomic,strong) NSArray *project_tag_list;
@property (nonatomic,copy) NSString *project_brief;
@property (nonatomic,copy) NSString *project_location;
@property (nonatomic,copy) NSString *biref_intro;
@property (nonatomic,copy) NSString *invest_stage;
@end

@interface CA_MDiscoverCompatible_project_data : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSArray<CA_MDiscoverCompatible_project_list*> *compatible_project_list;
@end

@interface CA_MDiscoverProduct_list : CA_HBaseModel
@property (nonatomic,copy) NSString *product_type;
@property (nonatomic,copy) NSString *product_website;
@property (nonatomic,copy) NSString *product_intro;
@property (nonatomic,copy) NSString *product_name;
@end

@interface CA_MDiscoverProduct_data : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSArray<CA_MDiscoverProduct_list*> *product_list;
@end

@interface CA_MDiscoverMember_list : CA_HBaseModel
@property (nonatomic,copy) NSString *member_logo;
@property (nonatomic,copy) NSString *member_name;
@property (nonatomic,copy) NSString *member_position;
@property (nonatomic,copy) NSString *member_intro;
@end

@interface CA_MDiscoverMember_data : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSArray<CA_MDiscoverMember_list*> *member_list;
@end

@interface CA_MDiscoverGp_list : CA_HBaseModel
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *gp_name;
@end

@interface CA_MDiscoverInvestHistory_list : CA_HBaseModel
@property (nonatomic,strong) NSNumber *invest_date;
@property (nonatomic,copy) NSString *invest_stage;
@property (nonatomic,copy) NSString *invest_money;
@property (nonatomic,strong) NSArray<CA_MDiscoverGp_list*> *gp_list;
@end

@interface CA_MDiscoverProjectDetailModel : CA_HBaseModel
@property (nonatomic,copy) NSString *data_type;//"project",
@property (nonatomic,copy) NSString *data_id;//"xxxxxx",
@property (nonatomic,copy) NSString *project_logo;//"项目logo URL",
@property (nonatomic,copy) NSString *project_name;//"项目名称",
@property (nonatomic,copy) NSString *project_area;//"北京",
@property (nonatomic,strong) NSNumber *project_publish_date;//"项目发布日期"，
@property (nonatomic,copy) NSString *project_invest_stage;//"项目最新融资轮次"，
@property (nonatomic,strong) NSNumber *invest_stage_id;
@property (nonatomic,copy) NSArray *tag_list;//["xxx", "xxx", ...], # 项目标签
@property (nonatomic,copy) NSString *enterprise_intro;//"公司简介"，
@property (nonatomic,copy) NSString *enterprise_name;//"公司名称"，
@property (nonatomic,copy) NSString *enterprise_keyno;//"xxx", # 跳转到企业详情所需字段
@property (nonatomic,copy) NSString *oper_name;//"法人名称"，
@property (nonatomic,strong) NSNumber *company_register_date;//"公司注册时间",
@property (nonatomic,strong) NSArray<CA_MDiscoverInvestHistory_list*> *invest_history_list;
@property (nonatomic,strong) CA_MDiscoverMember_data *member_data;
@property (nonatomic,strong) CA_MDiscoverProduct_data *product_data;
@property (nonatomic,strong) CA_MDiscoverCompatible_project_data *compatible_project_data;
@property (nonatomic,strong) CA_MDiscoverNews_data *news_data;

//
@property (nonatomic,strong) NSArray *headerTitles;
@property (nonatomic,strong) NSArray *footerTitles;
@end
