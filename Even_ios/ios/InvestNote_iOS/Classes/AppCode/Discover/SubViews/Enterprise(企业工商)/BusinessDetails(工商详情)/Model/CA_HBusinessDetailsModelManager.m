//
//  CA_HBusinessDetailsModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessDetailsModelManager.h"

@interface CA_HBusinessDetailsModelManager ()

@end

@implementation CA_HBusinessDetailsModelManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadDetail {
    NSDictionary *parameters =
  @{@"data_type": @"enterprisebusinessinfo",
    @"data_str": self.dataStr?:@""};
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_M_SearchFundDataDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]
                &&
                [NSObject isValueableObject:netModel.data]) {
                self.model = [CA_HEnterpriseBusinessInfoModel modelWithDictionary:netModel.data];
                self.model.creditreport_data_list.enterprise_id = self.model.keyno;
                self.model.creditreport_data_list.enterprise_name = self.model.enterprise_name;
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
