//
//  CA_HRemarkViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_HRemarkViewController : CA_HBaseViewController

@property (nonatomic, copy) void (^backBlock)(NSString * text);

@property (nonatomic, copy) NSString * placeholderText;
@property (nonatomic, copy) NSString * text;

@end
