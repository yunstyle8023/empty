//
//  CA_HFoundSearchController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HFoundSearchModelManager.h"

@interface CA_HFoundSearchController : CA_HBaseViewController

@property (nonatomic, strong) CA_HFoundSearchModelManager *modelManager;
@property (nonatomic, copy) NSString *searchText;

@end
