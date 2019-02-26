//
//  CA_HListHumanModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_MPersonModel.h"

@interface CA_HListHumanModel : CA_HBaseModel

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSMutableArray<CA_MPersonModel *> *data;
@property (nonatomic, copy) void (^finishRequestBlock)(CA_H_RefreshType type);
@property (nonatomic, copy) void (^loadMoreBlock)(NSString *keyword);

@end
