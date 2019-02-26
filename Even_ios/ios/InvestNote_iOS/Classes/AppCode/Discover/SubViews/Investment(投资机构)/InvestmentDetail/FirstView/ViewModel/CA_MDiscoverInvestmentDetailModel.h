//
//  CA_MDiscoverInvestmentDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverInvestmentDetailMemberDict : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSArray<CA_MDiscoverMember_list *> *member_list;
@end

@interface CA_MDiscoverInvestmentDetailBaseInfo : CA_HBaseModel
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *capital_type;
@property (nonatomic,copy) NSString *found_date;
@property (nonatomic,copy) NSString *gp_intro;
@property (nonatomic,copy) NSString *gp_name;
@property (nonatomic,strong) NSNumber *business_trace_total_count;
@end

@interface CA_MDiscoverInvestmentDetailModel : CA_HBaseModel
//"base_info": {
//    "area": "北京市",
//    "capital_type": "外资",
//    "found_date": "1992年",
//    "gp_intro": "是与企业家、行业领袖、各级政府部门间所建立的良好关系，致力于长期参与中国卓越企业的发展。",
//    "gp_name": "IDG资本"
//},
//"data_id": "0c2a1b8eada4803abd90386df241cbf3",
//"data_type": "project",
//"gp_moudle":

@property (nonatomic,strong) CA_MDiscoverInvestmentDetailBaseInfo *base_info;
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) CA_MDiscoverInvestmentDetailMemberDict *member_dict;
@property (nonatomic,strong) NSArray<CA_MDiscoverSponsorLp_moudle *> *gp_moudle;
@end
