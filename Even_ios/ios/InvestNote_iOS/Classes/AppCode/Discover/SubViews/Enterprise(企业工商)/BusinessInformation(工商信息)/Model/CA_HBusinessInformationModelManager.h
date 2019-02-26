//
//  CA_HBusinessInformationModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationModelManager : NSObject

- (NSArray *)data:(NSInteger)section;

@property (nonatomic, strong) CA_HBusinessInformationModel *model;

@property (nonatomic, copy) NSString *dataStr;

@property (nonatomic, copy) void (^loadDetailBlock)(BOOL success);
- (void)loadDetail;

@end
