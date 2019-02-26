//
//  CA_MDiscoverSponsorItemDetailModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverSponsorItemProjectData_list : CA_HBaseModel
@property (nonatomic,strong) NSNumber *project_id;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *equity_ratio;
@property (nonatomic,copy) NSString *invest_amount;
@property (nonatomic,copy) NSString *invest_date;
@property (nonatomic,copy) NSString *investor_name;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *round;
@end

@interface CA_MDiscoverSponsorItemProjectModel : CA_HBaseModel
//"data_list": [
//              {
//                  "category": "光电显示器",
//                  "equity_ratio": "3.35",
//                  "invest_amount": "6.0900亿人民币",
//                  "invest_date": "2016.09.30",
//                  "investor_name": "福建电子信息产业投资",
//                  "project_id": 1,
//                  "project_name": "华映科技",
//                  "round": "上市定增"
//              }
//              ],
//"data_type": "invest_project",
//"page_num": 1,
//"page_size": 10,
//"total_count": 3,
//"total_page": 1
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverSponsorItemProjectData_list *> *data_list;
@end
