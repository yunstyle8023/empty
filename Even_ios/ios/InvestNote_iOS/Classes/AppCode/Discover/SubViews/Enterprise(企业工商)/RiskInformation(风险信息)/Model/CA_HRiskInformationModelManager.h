//
//  CA_HRiskInformationModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HListRiskInfoModel.h"

@interface CA_HRiskInformationModelManager : NSObject

@property (nonatomic, copy) NSString *keyno;
@property (nonatomic, copy) NSString *searchName;
@property (nonatomic, copy) NSString *dataType;

@property (nonatomic, strong) CA_HListRiskInfoModel *model;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, copy) void (^finishBlock)(BOOL noMore);
- (void)loadMore:(NSNumber *)pageNum;

@end
