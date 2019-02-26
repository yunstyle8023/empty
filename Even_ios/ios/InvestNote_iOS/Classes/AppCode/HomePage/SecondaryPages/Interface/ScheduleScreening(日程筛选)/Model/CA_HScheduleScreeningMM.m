//
//  CA_HScheduleScreeningMM.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleScreeningMM.h"

@interface CA_HScheduleScreeningMM ()

@end

@implementation CA_HScheduleScreeningMM

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (void)postlistCompanyUser:(void(^)(CA_HNetModel * netModel))callBack {
    
    [CA_HNetManager postUrlStr:CA_H_Api_ListCompanyUser parameters:nil callBack:^(CA_HNetModel *netModel) {
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

@end
