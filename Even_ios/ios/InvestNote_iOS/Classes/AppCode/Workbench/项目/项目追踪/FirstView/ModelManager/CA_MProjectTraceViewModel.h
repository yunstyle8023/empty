//
//  CA_MProjectTraceViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MProjectTraceViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSMutableArray *data_list;

@property (nonatomic,copy) void(^loadDataBlock)(NSNumber *project_id);

@property (nonatomic,copy) void(^refreshBlock)(NSNumber *project_id);

@property (nonatomic,assign,getter=isShowLoading) BOOL showLoading;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

@end



