//
//  CA_MDiscoverSponsorDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverSponsorContact_data : CA_HBaseModel
@property (nonatomic,copy) NSString *contact_name;
@property (nonatomic,copy) NSString *contact_tel;
@property (nonatomic,copy) NSString *contact_email;
@property (nonatomic,strong) NSNumber *import_count;
@end

@interface CA_MDiscoverSponsorInclude_data : CA_HBaseModel
@property (nonatomic,assign) BOOL *is_imported;
@property (nonatomic,strong) NSNumber *import_count;
@end

@interface CA_MDiscoverSponsorLp_moudle : CA_HBaseModel
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *module_logo;
@property (nonatomic,copy) NSString *module_name;
@property (nonatomic,copy) NSString *module_type;
@property (nonatomic,strong) NSNumber *total_count;
@end

@interface CA_MDiscoverSponsorMember_list : CA_HBaseModel
@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,copy) NSString *member_name;
@property (nonatomic,copy) NSString *member_mail;
@property (nonatomic,copy) NSString *member_tel;
@property (nonatomic,copy) NSString *member_position;
@end

@interface CA_MDiscoverSponsorBase_info : CA_HBaseModel

//"lp_name": "xxx",
//"lp_area": "xxx",
//"found_date": "2013.04成立",
//"tags": ["xx", "xx"],
//"lp_enname": "英文全称"，
//"capital_type": "xxx",
//"managerial_capital": "管理资本量",
//"lp_type": "xxx",
//"vcpeform": "组织形式"，
//"address": "xxx",
//"state_background": "国有背景详情"，
//"lp_desc": "xxxx"

@property (nonatomic,copy) NSString *lp_name;
@property (nonatomic,copy) NSString *lp_area;
@property (nonatomic,copy) NSString *found_date;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,copy) NSString *lp_enname;
@property (nonatomic,copy) NSString *capital_type;
@property (nonatomic,copy) NSString *managerial_capital;
@property (nonatomic,copy) NSString *lp_type;
@property (nonatomic,copy) NSString *vcpeform;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *state_background;
@property (nonatomic,assign) BOOL state_background_unfold;
@property (nonatomic,copy) NSString *lp_desc;
@property (nonatomic,assign) BOOL lp_desc_unfold;
@end

@interface CA_MDiscoverSponsorDetailModel : CA_HBaseModel
@property (nonatomic,strong) NSArray *headerTitles;
@property (nonatomic,strong) CA_MDiscoverSponsorBase_info *base_info;
@property (nonatomic,strong) NSArray<CA_MDiscoverSponsorMember_list *> *member_list;
@property (nonatomic,strong) NSArray<CA_MDiscoverSponsorLp_moudle *> *lp_moudle;
@property (nonatomic,strong) CA_MDiscoverSponsorInclude_data  *include_data;
@property (nonatomic,strong) CA_MDiscoverSponsorContact_data *contact_data;
@end
