//
//  CA_MBandingNumberVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_MBandingNumberVC : CA_HBaseViewController
@property (nonatomic,copy) NSString *navigationTitle;
@property (nonatomic,copy) NSString *buttonTitle;
@property (nonatomic,assign,getter=isChangeNumber) BOOL changeNumber;
@property (nonatomic,copy) dispatch_block_t block;
@end

