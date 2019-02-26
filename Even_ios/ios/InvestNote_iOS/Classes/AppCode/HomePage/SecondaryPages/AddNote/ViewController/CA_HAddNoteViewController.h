//
//  CA_HAddNoteViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

#import "CA_HAddNoteViewModel.h"
#import "CA_MProjectModel.h"

@interface CA_HAddNoteViewController : CA_HBaseViewController

@property (nonatomic, strong) CA_HAddNoteViewModel *viewModel;

@property (nonatomic, strong) NSNumber *humamId;
@property (nonatomic, strong) CA_MProjectModel *projectModel;

@end
