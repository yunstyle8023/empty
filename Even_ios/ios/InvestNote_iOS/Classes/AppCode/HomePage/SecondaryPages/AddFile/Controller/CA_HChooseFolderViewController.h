//
//  CA_HChooseFolderViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseScrollController.h"

@class CA_HBrowseFoldersModel;
@interface CA_HChooseFolderViewController : CA_HBaseScrollController

@property (nonatomic, copy) UIViewController *(^chooseBlock)(CA_HBrowseFoldersModel *parentModel);

@end
