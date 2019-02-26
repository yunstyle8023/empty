//
//  CA_MAddPersonVC.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_MPersonDetailModel.h"

@interface CA_MAddPersonVC : CA_HBaseViewController
@property (nonatomic,copy) NSString *naviTitle;
@property (nonatomic,copy) void(^block)(id obj);
@property (nonatomic,strong) CA_MHuman_detail *model;
@end
