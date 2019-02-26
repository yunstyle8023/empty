//
//  CA_HTodoDetailViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HTodoDetailViewModel.h"

@interface CA_HTodoDetailViewController : CA_HBaseViewController

@property (nonatomic, strong) CA_HTodoDetailViewModel *viewModel;

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) void (^deleteBlock)(void);

@end
