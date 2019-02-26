//
//  CA_HFoundSearchModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HFoundSearchDataModel : CA_HBaseModel

// 项目
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_color;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *invest_stage;
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,copy) NSString *data_id;

@property(nonatomic, copy) NSAttributedString *project_name_attributedText;
@property (nonatomic,copy) NSAttributedString *brief_intro_attributedText;

// 企业工商
@property (nonatomic,copy) NSString *enterprise_name;//"公司名称",
@property (nonatomic,copy) NSString *opername;//"法人名称",
@property (nonatomic,copy) NSString *keyno;//"企业内部key_number" ,
@property (nonatomic,copy) NSString *setup_date;//"成立日期",
@property (nonatomic,copy) NSString *status;//"企业状态",
@property (nonatomic,copy) NSString *status_color;//"企业状态颜色"

@property (nonatomic,copy) NSAttributedString *enterprise_name_attributedText;

// 出资人
@property (nonatomic,copy) NSString *lp_name;//"test",
@property (nonatomic,copy) NSString *lp_intro;//"这是一个公司简介或者机构描述的语句存放的地方",
@property (nonatomic,copy) NSString *lp_type;
//"data_id": 1

@property(nonatomic, copy) NSAttributedString *lp_name_attributedText;
@property (nonatomic,copy) NSAttributedString *lp_intro_attributedText;

// 出资机构
@property (nonatomic,copy) NSString *area;//"北京市",
@property (nonatomic,copy) NSString *capital_type;//"外资",
//"data_id": "0c2a1b8eada4803abd90386df241cbf3",
@property (nonatomic,copy) NSString *data_type;//"gp",
@property (nonatomic,copy) NSString *gp_intro;//"IDG资本专注于与中国市场有关的VC/PE投资项目，在香港、北京、上海、广州、深圳等地设有办事处。管理资本量超过50亿美元。 IDG资本重点关注消费品、连锁服务、互联网及无线应用、新媒体、教育、医疗健康、新能源、先进制造等领域的拥有一流品牌的领先企业，覆盖初创期、成长期、成熟期、Pre-IPO各个阶段，投资规模从上百万美元到上千万美元不等。 IDG资本获得了国际数据集团（IDG）和ACCEL Partners的支持，拥有广泛的海外市场资源及强大的网络支持。IDG资本深感自豪的是与企业家、行业领袖、各级政府部门间所建立的良好关系，致力于长期参与中国卓越企业的发展。",
@property (nonatomic,copy) NSString *gp_logo;//"http://qichacha.oss-cn-qingdao.aliyuncs.com/Investment/logo/0c2a1b8eada4803abd90386df241cbf3.jpg",
@property (nonatomic,copy) NSString *gp_name;//"IDG资本"

@property(nonatomic, copy) NSAttributedString *gp_name_attributedText;
@property (nonatomic,copy) NSAttributedString *gp_intro_attributedText;
@property (nonatomic,copy) NSAttributedString *gp_show_attributedText;

@end

@interface CA_HFoundSearchModel : CA_HBaseModel

@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSArray<CA_HFoundSearchDataModel *> *data_list;

@end

@interface CA_HFoundSearchAggregationModel : CA_HBaseModel

@property (nonatomic,strong) CA_HFoundSearchModel *project_data;
@property (nonatomic,strong) CA_HFoundSearchModel *enterprise_data;
@property (nonatomic,strong) CA_HFoundSearchModel *lp_data;
@property (nonatomic,strong) CA_HFoundSearchModel *gp_data;

@end
