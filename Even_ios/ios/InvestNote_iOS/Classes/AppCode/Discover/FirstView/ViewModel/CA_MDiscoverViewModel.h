//
//  CA_MDiscoverViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverModel;
@class CA_MDiscoverInvestmentFilterData;

@interface CA_MDiscoverViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *search_str;
@property (nonatomic,copy) NSString *search_type;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) CA_MDiscoverModel *discoverModel;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,assign,getter=isFilter) BOOL filter;
-(void)loadFilterData:(void(^)(CA_MDiscoverInvestmentFilterData *filterData))block;
@end
