//
//  CA_MNewSearchProjectVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_MNewSearchProjectVC : CA_HBaseViewController

@property (nonatomic,strong) NSNumber *project_id;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

@end
