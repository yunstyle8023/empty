//
//  CA_HNoteDetailController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HNoteDetailModelManager.h"

@interface CA_HNoteDetailController : CA_HBaseViewController

@property (nonatomic, strong) CA_HNoteDetailModelManager *modelManager;
@property (nonatomic, strong) NSNumber *noteId;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
