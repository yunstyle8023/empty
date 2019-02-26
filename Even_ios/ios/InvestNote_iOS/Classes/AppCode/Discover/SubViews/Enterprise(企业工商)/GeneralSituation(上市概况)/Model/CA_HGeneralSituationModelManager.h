//
//  CA_HGeneralSituationModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HGeneralSituationModelManager : NSObject

@property (nonatomic, copy) NSString *stockCode;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) void (^loadDetailBlock)(BOOL success);
- (void)loadDetail;

@end
