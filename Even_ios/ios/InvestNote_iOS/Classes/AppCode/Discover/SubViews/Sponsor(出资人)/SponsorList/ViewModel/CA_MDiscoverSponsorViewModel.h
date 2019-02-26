//
//  CA_MDiscoverSponsorViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MDiscoverSponsorViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,copy) NSString *tagName;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSNumber *investor_recommend_count;

@property (nonatomic,copy) dispatch_block_t refreshBlock;

@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@end
