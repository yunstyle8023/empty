//
//  CA_MPersonDetailVC.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MPersonModel.h"

@interface CA_MPersonDetailVC : CA_HBaseViewController
@property (nonatomic,strong) NSNumber *humanID;
@property (nonatomic,strong) NSNumber *fileID;
@property (nonatomic,strong) NSArray *filePath;
@end
