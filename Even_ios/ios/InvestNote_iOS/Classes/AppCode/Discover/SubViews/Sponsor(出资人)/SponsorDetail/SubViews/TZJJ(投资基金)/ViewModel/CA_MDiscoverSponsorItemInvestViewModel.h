//
//  CA_MDiscoverSponsorItemInvestViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverSponsorItemInvestModel;
@interface CA_MDiscoverSponsorItemInvestViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *lpId;
@property (nonatomic,strong) CA_MDiscoverSponsorItemInvestModel *listModel;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;
@end
