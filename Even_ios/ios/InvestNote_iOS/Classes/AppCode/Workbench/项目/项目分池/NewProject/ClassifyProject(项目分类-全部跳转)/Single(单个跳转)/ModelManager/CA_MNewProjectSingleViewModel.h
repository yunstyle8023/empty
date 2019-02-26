//
//  CA_MNewProjectSingleViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MProjectNetModel,CA_MNewProjectListModel;

@interface CA_MNewProjectSingleViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSMutableArray *tagNames;

@property (nonatomic,strong) NSMutableArray *tagViews;

@property (nonatomic,strong) CA_MProjectNetModel *netModel;

@property (nonatomic,strong) NSNumber *pool_id;

@property (nonatomic,strong) NSNumber *tag_id;

@property (nonatomic,strong) CA_MNewProjectListModel *listModel;

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,assign,getter=isFiltrating) BOOL filtrating;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) void(^(finishedBlock))(BOOL isHasMore);

@end
