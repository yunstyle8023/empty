//
//  CA_MDiscoverProjectDetailViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverProjectDetailModel;
@interface CA_MDiscoverProjectDetailViewModel : NSObject
@property (nonatomic,copy) NSString *dataID;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) CA_MDiscoverProjectDetailModel *detailModel;
@property (nonatomic,copy) dispatch_block_t finishedBlock;
@property (nonatomic,assign,getter=isFinished) BOOL finished;
@end
