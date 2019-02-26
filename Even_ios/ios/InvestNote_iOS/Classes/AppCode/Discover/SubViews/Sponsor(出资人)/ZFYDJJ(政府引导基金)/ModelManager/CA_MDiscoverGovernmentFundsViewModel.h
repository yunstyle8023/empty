//
//  CA_MDiscoverGovernmentFundsViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MDiscoverGovernmentFundsViewModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,copy) NSString *data_type;

@property (nonatomic,copy) NSString *search_type;

@property (nonatomic,strong) NSNumber *total_count;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@property (nonatomic,assign,getter=isShowLoading) BOOL showLoading;

@property (nonatomic,copy) dispatch_block_t loadDataBlock;

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);

@end
