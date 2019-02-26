//
//  CA_HBusinessDetailsModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HEnterpriseBusinessInfoModel.h"

@interface CA_HBusinessDetailsModelManager : NSObject

@property (nonatomic, strong) CA_HEnterpriseBusinessInfoModel *model;

@property (nonatomic, copy) NSString *dataStr;

@property (nonatomic, copy) void (^loadDetailBlock)(BOOL success);
- (void)loadDetail;

@end
