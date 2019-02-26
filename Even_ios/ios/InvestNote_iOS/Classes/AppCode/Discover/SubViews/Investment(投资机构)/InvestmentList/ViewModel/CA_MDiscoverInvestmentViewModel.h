//
//  CA_MDiscoverInvestmentViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverInvestmentModel;
@class CA_MDiscoverInvestmentFilterData;

@interface CA_MDiscoverInvestmentViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *search_str;
@property (nonatomic,copy) NSString *search_type;

@property (nonatomic,strong) CA_MDiscoverInvestmentModel *investmentModel;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;

@property (nonatomic,assign,getter=isFilter) BOOL filter;
-(void)loadFilterData:(void(^)(CA_MDiscoverInvestmentFilterData *filterData))block;
@end
