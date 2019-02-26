//
//  CA_HLoginManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HLoginManager.h"

#import "CA_HHomePageViewController.h"

@implementation CA_HLoginManager

+ (void)loginOrganization: (NSDictionary *) parameters callBack: (void(^)(CA_HNetModel * netModel)) callBack {
    [CA_HNetManager postUrlStr:CA_M_Api_OrganizationLogin parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess
            &&
            netModel.errcode.integerValue == 0
            &&
            netModel.data) {

            [CA_H_UserDefaults setObject:parameters forKey:NSLoginAccount];
            [CA_H_MANAGER saveToken:netModel.data[@"token"]];

            NSNumber *notifyCount = netModel.data[@"notify_count"];
            CA_H_MANAGER.tabbarPoint.hidden = !(notifyCount.integerValue>0);

            [CA_HHomePageViewController reloadData];
        }
        
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

@end
