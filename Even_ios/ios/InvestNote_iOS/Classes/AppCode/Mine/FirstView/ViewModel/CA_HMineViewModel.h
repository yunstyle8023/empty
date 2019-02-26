//
//  CA_HMineViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HMineModel.h"

@interface CA_HMineViewModel : NSObject

@property (nonatomic, strong) CA_HMineModel *model;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *imgs;
@end
