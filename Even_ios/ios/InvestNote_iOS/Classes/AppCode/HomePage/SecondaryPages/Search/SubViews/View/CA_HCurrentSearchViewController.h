//
//  CA_HCurrentSearchViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HCurrentSearchViewModel.h"
#import "CA_HCurrentSearchViewManager.h"

@interface CA_HCurrentSearchViewController : CA_HBaseViewController

@property (nonatomic, strong) CA_HCurrentSearchViewModel *viewModel;
@property (nonatomic, strong) CA_HCurrentSearchViewManager *viewManager;

@end
