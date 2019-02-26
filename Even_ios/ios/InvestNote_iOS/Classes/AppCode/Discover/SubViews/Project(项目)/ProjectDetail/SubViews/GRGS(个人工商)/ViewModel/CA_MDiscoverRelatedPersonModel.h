//
//  CA_MDiscoverRelatedPersonModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverRelatedPersonRequestModel : CA_HBaseModel
//enterprise_str    是    string    企业名称
//person_name    是    string    个人名称
//position_type    是    string    职位类型（all,legal_person,stock_holder,in_office）
//page_size    是    int    分页页数
//page_num

@property (nonatomic,copy) NSString *enterprise_str;
@property (nonatomic,copy) NSString *person_name;
@property (nonatomic,copy) NSString *position_type;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@end

@interface CA_MDiscoverRelatedPersonData_list : CA_HBaseModel
//                  "opername": "王思聪",
//                  "position_desc": "xxxxxxx",
//                  "enterprise_name": "苏州市平江区大歌星超市",
//                  "regist_capi": null,
//                  "status_color": "xxx",
//                  "status": "注销",
//                  "other_position": "xxxx",
//                  "ratio": "xxx",
//                  "keyno": "xxxxx",# 根据企业名称和keyno实现跳转
@property (nonatomic,copy) NSString *opername;
@property (nonatomic,copy) NSString *position_desc;
@property (nonatomic,copy) NSString *enterprise_name;
@property (nonatomic,copy) NSString *regist_capi;
@property (nonatomic,copy) NSString *status_color;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *other_position;
@property (nonatomic,copy) NSString *ratio;
@property (nonatomic,copy) NSString *keyno;
@end

@interface CA_MDiscoverRelatedPersonModel : CA_HBaseModel
//"total_count": 122,
//"page_size": 10,
//"page_num": 1,
//"data_list": [
//              {
//                  "opername": "王思聪",
//                  "position_desc": "xxxxxxx",
//                  "enterprise_name": "苏州市平江区大歌星超市",
//                  "regist_capi": null,
//                  "status_color": "xxx",
//                  "status": "注销",
//                  "other_position": "xxxx",
//                  "ratio": "xxx",
//                  "keyno": "xxxxx",# 根据企业名称和keyno实现跳转
//              },
//              ]
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverRelatedPersonData_list *> *data_list;
@end
