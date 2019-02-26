//
//  CA_MFiltrateItemViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Request_Post,
    Request_Get
} Request_Method;

@interface CA_MFiltrateItemViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,assign) Request_Method requestMethod;

@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,strong) NSDictionary *parameters;

@property (nonatomic,copy) NSString *className;

@property (nonatomic,copy) dispatch_block_t loadDataBlock;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) void(^(finishedBlock))(NSMutableArray *dataSource);

@end
