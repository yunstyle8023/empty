//
//  CA_MDiscoverModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"


@interface CA_MDiscoverSponsorRequestModel : CA_HBaseModel
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *search_type;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@end

@interface CA_MDiscoverRequestModel : CA_HBaseModel
//"data_type": "investment",
//"search_str": "latest",  # 这里是否需要取出search_str来进行二次判断？-是否需要固定到search_str值
//"search_type": "latest", # 最新的
//"page_size": 10,
//"page_num": 1
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *search_str;
@property (nonatomic,copy) NSString *search_type;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@end

@interface CA_MModuleModel : CA_HBaseModel
@property (nonatomic,copy) NSString *module_name;
@property (nonatomic,copy) NSString *module_logo;
@property (nonatomic,copy) NSString *data_type;
@end

@interface CA_MCommonModel : CA_HBaseModel
//"enterprise_name": "所属企业名称",
//"project_id": "被投项目ID",
//"project_name": "被投项目名称" ,
//"investor": "投资机构",
//"invest_money": "融资金额"，
//"invest_round": "融资轮次",
//"invest_date": "融资日期",
@property (nonatomic,copy) NSString *enterprise_name;
@property (nonatomic,copy) NSString *project_id;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *investor;
@property (nonatomic,copy) NSString *invest_money;
@property (nonatomic,copy) NSString *invest_round;
@property (nonatomic,strong) NSNumber *invest_date;

//"project_logo": "xxx",
//"project_name": "项目名称",
//"invest_stage": "A", # 融资阶段
//"biref_intro": "这是一个公司简介或者机构描述的语句存放的地方",
//"data_id": 1
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_color;
//@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *invest_stage;
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,copy) NSString *data_id;

@end

@interface CA_MDiscoverModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSMutableArray<CA_MCommonModel *> *data_list;
@property (nonatomic,strong) NSMutableArray<CA_MModuleModel *> *modules_list;
@end
