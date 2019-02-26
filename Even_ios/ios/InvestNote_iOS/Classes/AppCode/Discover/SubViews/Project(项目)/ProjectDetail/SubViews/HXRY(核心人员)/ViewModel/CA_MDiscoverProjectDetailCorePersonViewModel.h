//
//  CA_MDiscoverProjectDetailCorePersonViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverProjectDetailRequestModel;

@interface CA_MDiscoverProjectDetailCorePersonViewModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *dataID;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,copy) NSString *cellClass;
@property (nonatomic,strong) CA_MDiscoverProjectDetailRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end
