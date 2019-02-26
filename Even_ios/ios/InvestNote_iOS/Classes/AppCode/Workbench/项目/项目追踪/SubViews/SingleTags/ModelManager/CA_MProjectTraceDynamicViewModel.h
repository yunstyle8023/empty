//
//  CA_MProjectTraceDynamicViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MRequestModel;

@interface CA_MProjectTraceDynamicViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSNumber *project_id;

@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,copy) NSString *modelClass;

@property (nonatomic,strong) CA_MRequestModel *requestModel;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign,getter=isFirstLoad) BOOL firstLoad;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@end
