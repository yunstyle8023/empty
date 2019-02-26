//
//  CA_MNewSearchProjectViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MSelectProjectNetModel;
@class CA_MSelectModel;

@interface CA_MNewSearchProjectViewModel : NSObject

@property (nonatomic,copy) NSString *title;

@property(nonatomic,strong)NSMutableArray<CA_MSelectModel *> *dataSource;

@property (nonatomic,strong) CA_MSelectProjectNetModel *netModel;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) void(^finishedBlock)(BOOL isHasData);

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreDataBlock;

@property (nonatomic,copy) void(^relevanceBlock)(NSNumber *project_id,NSString *data_id,dispatch_block_t block);

@end
