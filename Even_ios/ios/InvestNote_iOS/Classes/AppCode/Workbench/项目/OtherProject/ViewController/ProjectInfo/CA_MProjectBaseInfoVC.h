//
//  CA_MProjectBaseInfoVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MProjectDetailModel.h"

@interface CA_MProjectBaseInfoVC : CA_HBaseViewController
@property (nonatomic,strong) CA_MProjectDetailModel *model;
@property (nonatomic,copy) void(^block)(void);
@end
