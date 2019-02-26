//
//  CA_HFinancialDataModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFinancialDataModelManager.h"

@interface CA_HFinancialDataModelManager ()

@end

@implementation CA_HFinancialDataModelManager

#pragma mark --- Action

#pragma mark --- Lazy

- (NSArray *)data {
    switch (self.item) {
        case 0:
            return self.assets_liabilities;
        case 1:
            return self.profits;
        case 2:
            return self.cash_flow;
        default:
            return nil;
    }
}

- (NSString *)financialType {
    switch (self.item) {
        case 0:
            return @"assets_liabilities";
        case 1:
            return @"profits";
        case 2:
            return @"cash_flow";
        default:
            return @"";
    }
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadDetail:(NSString *)financialDate {
    
    if (!financialDate) {
        if (self.loadDetailBlock) self.loadDetailBlock(NO);
        return;
    }
    
    NSDictionary *parameters =
    @{@"data_type": @"financialdata",
      @"financial_type": self.financialType,
      @"stock_code": self.stockCode?:@"",
      @"financial_date": financialDate
      };
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_QueryEnterpriseFinancialData parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]
                &&
                [NSObject isValueableObject:netModel.data]) {
                
                
                
                NSString *text = netModel.data[@"financial_date"];
                
                if (![self.financialDate isEqualToString:text]) {
                    self.financialDate = text;
                    self.assets_liabilities = nil;
                    self.profits = nil;
                    self.cash_flow = nil;
                }
                
                self.dateList = netModel.data[@"date_list"];
                
                switch (self.item) {
                    case 0:
                        self.assets_liabilities = netModel.data[@"data_list"];
                        break;
                    case 1:
                        self.profits = netModel.data[@"data_list"];
                        break;
                    case 2:
                        self.cash_flow = netModel.data[@"data_list"];
                        break;
                    default:
                        break;
                }
                
                
                if (self.loadDetailBlock) self.loadDetailBlock(YES);
                return ;
            }
        }
        
        if (self.loadDetailBlock) self.loadDetailBlock(NO);
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

#pragma mark --- Delegate

@end
