//
//  CA_HEnterpriseBusinessInfoModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HEnterpriseModules : CA_HBaseModel//信息

// base 基本信息
@property (nonatomic, copy) NSString *module_name;//"工商信息",
@property (nonatomic, copy) NSString *module_logo;//"xxxxxxx",
@property (nonatomic, copy) NSString *data_type;//"enterprise"

// risk 失信信息
@property (nonatomic, strong) NSNumber *nums;//失信信息数量

// stock 上市信息
@property (nonatomic, copy) NSString *financial_date;//"2018一季度", # 财务数据时间
@property (nonatomic, copy) NSString *stock_code;//"股票代码",
@property (nonatomic, strong) NSArray *financial_type;//[\
"assets_liabilities",\
"profits",\
"cash_flow"]

@end

@interface CA_HEnterpriseCreditreport : CA_HBaseModel//企业报告

@property (nonatomic, copy) NSString *order_no;//"订单No",
@property (nonatomic, strong) NSNumber *collect_count;//剩余下载次数

@property (nonatomic, copy) NSString *enterprise_id;//公司ID
@property (nonatomic, copy) NSString *enterprise_name;//公司名称

@end

@interface CA_HEnterpriseStock : CA_HBaseModel//上市数据

@property (nonatomic, strong) NSNumber *close_price;//收盘价格,
@property (nonatomic, strong) NSNumber *last_closing_date;//": 收盘日期, # 时间戳
@property (nonatomic, strong) NSNumber *p_change;//": 百分比变化,
@property (nonatomic, strong) NSNumber *price_change;//": 价格变化,
@property (nonatomic, copy) NSString *stock_code;//"股票代码"

@end

@interface CA_HEnterpriseBusinessInfoModel : CA_HBaseModel

@property (nonatomic, copy) NSString *data_type;//"enterprisebusinessinfo",
@property (nonatomic, copy) NSString *enterprise_name;//"企业名称",
@property (nonatomic, copy) NSString *keyno;//"企业keyNo",
@property (nonatomic, copy) NSString *status;//"企业状态",
@property (nonatomic, strong) NSNumber *is_on_stock;//1为上市公司，0为没有上市公司
@property (nonatomic, strong) CA_HEnterpriseStock *stock_data_list;
@property (nonatomic, strong) CA_HEnterpriseCreditreport *creditreport_data_list;
@property (nonatomic, strong) NSArray<CA_HEnterpriseModules *> *stock_modules_list;
@property (nonatomic, strong) NSArray<CA_HEnterpriseModules *> *basic_modules_list;
@property (nonatomic, strong) NSArray<CA_HEnterpriseModules *> *risk_modules_list;


@end
