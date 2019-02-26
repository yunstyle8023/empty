//
//  CA_MNewSelectProjectVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "MYPresentedController.h"
@class CA_MNewSelectProjectViewModel;

@interface CA_MNewSelectProjectVC : MYPresentedController

@property (nonatomic,strong) NSNumber *pool_id;

@property (nonatomic,assign) BOOL resultViewShow;

@property (nonatomic,strong) CA_MNewSelectProjectViewModel *viewModel;

@property (nonatomic,strong) NSMutableDictionary *selectedDic;

@property (nonatomic,copy) dispatch_block_t finished;

@end
