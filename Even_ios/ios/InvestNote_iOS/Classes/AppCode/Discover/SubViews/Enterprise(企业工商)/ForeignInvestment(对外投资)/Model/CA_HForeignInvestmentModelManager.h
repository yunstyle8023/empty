//
//  CA_HForeignInvestmentModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HInvestEventModel.h"

@interface CA_HForeignInvestmentModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) CA_HInvestEventModel *model;

@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, copy) void (^finishBlock)(BOOL noMore);
- (void)loadMore:(NSNumber *)pageNum;

@end
