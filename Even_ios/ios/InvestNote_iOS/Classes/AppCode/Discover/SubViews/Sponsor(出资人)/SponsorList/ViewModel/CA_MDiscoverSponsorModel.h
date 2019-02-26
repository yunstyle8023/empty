//
//  CA_MDiscoverSponsorModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverSponsorData_list : CA_HBaseModel
@property (nonatomic,copy) NSString *lp_name;
@property (nonatomic,copy) NSString *lp_intro;
@property (nonatomic,copy) NSString *lp_type;
@property (nonatomic,copy) NSString *data_id;

@property (nonatomic,copy) NSString *lp_logo;
@end

@interface CA_MDiscoverSponsorModel : CA_HBaseModel
//"data_type": "lp",
//"total_count": 122,
//"page_size": 10,
//"page_num": 1,
//"total_page": 13,
//"data_list": [
//              {
//                  "lp_name": "test",
//                  "lp_intro": "这是一个公司简介或者机构描述的语句存放的地方",
//                  "data_id": 1
//              }
//              ]
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSArray<CA_MDiscoverSponsorData_list *> *data_list;
@end
