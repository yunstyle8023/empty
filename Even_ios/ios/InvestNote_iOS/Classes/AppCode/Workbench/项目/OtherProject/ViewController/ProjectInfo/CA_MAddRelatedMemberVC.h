//
//  CA_MAddRelatedMemberVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MProjectModel.h"

@interface CA_MAddRelatedMemberVC : CA_HBaseViewController
@property (nonatomic,strong) CA_MProjectModel *model;
@property (nonatomic,copy) dispatch_block_t block;
@end
