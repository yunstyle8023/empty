//
//  CA_MProjectInfoVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MProjectDetailModel.h"

@interface CA_MProjectInfoVC : CA_HBaseViewController
@property (nonatomic,strong) CA_MProjectDetailModel *model;
@property (nonatomic,copy) dispatch_block_t block;
@end
