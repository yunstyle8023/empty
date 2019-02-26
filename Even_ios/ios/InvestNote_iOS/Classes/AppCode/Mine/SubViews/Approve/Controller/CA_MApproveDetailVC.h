//
//  CA_MApproveDetailVC.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_MApproveDetailVC : CA_HBaseViewController
@property (nonatomic,strong) NSNumber *approveID;
@property (nonatomic,copy) dispatch_block_t block;
@end
