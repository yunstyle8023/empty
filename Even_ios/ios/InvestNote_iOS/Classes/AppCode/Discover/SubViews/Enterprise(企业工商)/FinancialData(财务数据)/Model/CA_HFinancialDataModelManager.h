//
//  CA_HFinancialDataModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HFinancialDataModelManager : NSObject

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger item;

@property (nonatomic, copy) NSString *stockCode;//"股票代码",
@property (nonatomic, copy) NSString *financialType;
@property (nonatomic, copy) NSString *financialDate;//"2018一季度" # 查询季度财报
@property (nonatomic, strong) NSArray *dateList;

@property (nonatomic, strong) NSArray *assets_liabilities;//资产负债表
@property (nonatomic, strong) NSArray *profits;//利润表
@property (nonatomic, strong) NSArray *cash_flow;//现金流量表

@property (nonatomic, copy) void (^loadDetailBlock)(BOOL success);
- (void)loadDetail:(NSString *)financialDate;



@end
