//
//  CA_MDiscoverSponsorListViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverSponsorListModel;

@interface CA_MDiscoverSponsorListViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,strong) CA_MDiscoverSponsorListModel *listModel;
@property (nonatomic,copy) void(^finishedBlock) (BOOL isLoadMore,BOOL isHasData);
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;
@end
