//
//  CA_MProjectTraceMutilTagsViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MProjectTraceMutilTModel;
@class CA_MProjectTraceMutiltRequestModel;

@interface CA_MProjectTraceMutilTagsViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSMutableArray *tagNames;

@property (nonatomic,strong) NSMutableArray *tagViews;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSNumber *project_id;

@property (nonatomic,strong) CA_MProjectTraceMutiltRequestModel *requestModel;

@property (nonatomic,strong) CA_MProjectTraceMutilTModel *listModel;

@property (nonatomic,assign,getter=isFirstRequest) BOOL firstRequest;

@property (nonatomic,assign,getter=isHomePage) BOOL homePage;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) dispatch_block_t loadDataBlock;

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,copy) void(^(finishedBlock))(BOOL isHasMore);

@end
