//
//  CA_MNewSelectProjectViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MNewSelectProjectViewManager : NSObject
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UITableView *outerTableView;
@property (nonatomic,strong) UITableView *innerTableView;
@property (nonatomic,strong) UIButton *resetBtn;
@property (nonatomic,strong) UIButton *finishedBtn;
@property (nonatomic,copy) dispatch_block_t resetBlock;
@property (nonatomic,copy) dispatch_block_t finishedBlock;
@end
