//
//  CA_HLongViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/18.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HLongViewModel.h"

@interface CA_HLongViewController : CA_HBaseViewController

@property (nonatomic, strong) NSNumber *noteId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CA_HLongType type;

//新版生成长图
@property (nonatomic, strong) CA_HNoteDetailModel *model;

@end
