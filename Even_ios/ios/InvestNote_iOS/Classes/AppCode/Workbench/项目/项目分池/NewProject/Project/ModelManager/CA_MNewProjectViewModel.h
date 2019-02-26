//
//  CA_MNewProjectViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MNewProjectModel;

@interface CA_MNewProjectViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) CA_MNewProjectModel *model;

@property (nonatomic,assign,getter=isRefresh) BOOL refresh;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@end
