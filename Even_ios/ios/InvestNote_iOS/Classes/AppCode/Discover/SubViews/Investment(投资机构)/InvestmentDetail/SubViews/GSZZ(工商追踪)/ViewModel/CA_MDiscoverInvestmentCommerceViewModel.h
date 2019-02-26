//
//  CA_MDiscoverInvestmentCommerceViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MDiscoverInvestmentCommerceViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *gp_id;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;
@end
