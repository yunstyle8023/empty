//
//  CA_MDiscoverSponsorItemInvestModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverSponsorItemInvestRequestModel : CA_HBaseModel
@property (nonatomic,copy) NSString *lp_id;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@end

@interface CA_MDiscoverSponsorItemInvestData_list : CA_HBaseModel
@property (nonatomic,strong) NSNumber *fund_id;
@property (nonatomic,copy) NSString *capital_date;
@property (nonatomic,copy) NSString *fund_name;
@property (nonatomic,copy) NSString *fund_type;
@property (nonatomic,copy) NSString *promise_amount;
@property (nonatomic,copy) NSString *round;
@property (nonatomic,copy) NSString *target_size;
@end

@interface CA_MDiscoverSponsorItemInvestModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *total_page;
@property (nonatomic,strong) NSNumber *total_count;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverSponsorItemInvestData_list *> *data_list;
@end
