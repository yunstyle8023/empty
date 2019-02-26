//
//  CA_HBusinessInformationModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationModelManager.h"

@interface CA_HBusinessInformationModelManager ()

@end

@implementation CA_HBusinessInformationModelManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadDetail {
    NSDictionary *parameters =
    @{@"data_type": @"enterprise",
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
                self.model = [CA_HBusinessInformationModel modelWithDictionary:netModel.data];
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

- (NSArray *)data:(NSInteger)section {
    switch (section) {
        case 0:
            return self.model.basic_info_list;
        case 1:
            return self.model.partners_list;
        case 2:
            return self.model.main_member_list;
        case 3:
            return self.model.change_list;
        case 4:
            return self.model.branch_list;
        default:
            return nil;
    }
}

#pragma mark --- Delegate

@end
