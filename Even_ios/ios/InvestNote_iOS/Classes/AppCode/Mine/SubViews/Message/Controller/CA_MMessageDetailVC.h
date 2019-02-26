//
//  CA_MMessageDetailVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MMessageModel.h"

@interface CA_MMessageDetailVC : CA_HBaseViewController
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) dispatch_block_t block;
@end
