//
//  CA_HGeneralSituationModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HGeneralSituationModelManager.h"

@interface CA_HGeneralSituationModelManager ()

@end

@implementation CA_HGeneralSituationModelManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadDetail {
    NSDictionary *parameters =
    @{@"data_type": @"listedbasicinfo",
      @"stock_code": self.stockCode?:@""};
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_QueryEnterpriseListedInfo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]
                &&
                [NSObject isValueableObject:netModel.data]) {
                
                self.data = netModel.data[@"listedbasic_list"];
                
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
