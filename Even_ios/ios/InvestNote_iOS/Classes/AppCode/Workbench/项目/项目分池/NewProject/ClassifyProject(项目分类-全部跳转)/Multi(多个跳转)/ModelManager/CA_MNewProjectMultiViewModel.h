//
//  CA_MNewProjectMultiViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MNewProjectMultiViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

@end
