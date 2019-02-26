//
//  CA_HSearchReportModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HFoundReportModel.h"

@interface CA_HSearchReportModelManager : NSObject

@property (nonatomic, copy) NSString *dataType;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *headerText;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) CA_HFoundReportModel *model;

@property (nonatomic, copy) void (^finishBlock)(BOOL noMore);
- (void)loadMore:(NSNumber *)pageNum;

@end
