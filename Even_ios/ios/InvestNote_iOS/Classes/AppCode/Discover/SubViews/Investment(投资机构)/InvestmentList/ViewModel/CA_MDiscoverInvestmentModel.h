//
//  CA_MDiscoverInvestmentModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverInvestmentFilterData : CA_HBaseModel
@property (nonatomic,strong) NSArray *filter_captial_type;
@property (nonatomic,strong) NSArray *filter_area;

@property (nonatomic,strong) NSArray *filter_round;
@property (nonatomic,strong) NSArray *filter_time;

@property (nonatomic,strong) NSArray *filter_industry;
@end

@interface CA_MDiscoverInvestmentData_list : CA_HBaseModel
//"area": "北京市",
//"capital_type": "外资",
//"data_id": "0c2a1b8eada4803abd90386df241cbf3",
//"data_type": "gp",
//"gp_intro": "IDG资本专注于与中国市场有关的VC/PE投资项目，在香港、北京、上海、广州、深圳等地设有办事处。管理资本量超过50亿美元。 IDG资本重点关注消费品、连锁服务、互联网及无线应用、新媒体、教育、医疗健康、新能源、先进制造等领域的拥有一流品牌的领先企业，覆盖初创期、成长期、成熟期、Pre-IPO各个阶段，投资规模从上百万美元到上千万美元不等。 IDG资本获得了国际数据集团（IDG）和ACCEL Partners的支持，拥有广泛的海外市场资源及强大的网络支持。IDG资本深感自豪的是与企业家、行业领袖、各级政府部门间所建立的良好关系，致力于长期参与中国卓越企业的发展。",
//"gp_logo": "http://qichacha.oss-cn-qingdao.aliyuncs.com/Investment/logo/0c2a1b8eada4803abd90386df241cbf3.jpg",
//"gp_name": "IDG资本"

@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *capital_type;
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *gp_intro;
@property (nonatomic,copy) NSString *gp_logo;
@property (nonatomic,copy) NSString *gp_name;
@end

@interface CA_MDiscoverInvestmentModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverInvestmentData_list *> *data_list;
@end
