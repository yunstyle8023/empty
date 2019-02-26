//
//  CA_HChooseFolderListViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/21.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@class CA_HBrowseFoldersModel;
@interface CA_HChooseFolderListViewController : CA_HBaseViewController

@property (nonatomic, copy) UIViewController *(^chooseBlock)(CA_HBrowseFoldersModel *parentModel);

@end
