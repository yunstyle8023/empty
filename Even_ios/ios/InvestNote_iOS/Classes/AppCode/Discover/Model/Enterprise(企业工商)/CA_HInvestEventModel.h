//
//  CA_HInvestEventModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HInvestEventData : CA_HBaseModel

@property (nonatomic, copy) NSString *enterprise_name;//"小米科技有限责任公司仙桃分公司",
@property (nonatomic, copy) NSString *data_type;//"enterprisebusinessinfo"
@property (nonatomic, strong) NSArray *invest_data_list;//[

@end

@interface CA_HInvestEventModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *page_size;
@property (nonatomic, strong) NSNumber *page_num;
@property (nonatomic, copy) NSString *data_type;
@property (nonatomic, strong) NSNumber *total_count;
@property (nonatomic, strong) NSNumber *total_page;
@property (nonatomic, strong) NSArray<CA_HInvestEventData *> *data_list;

@end
