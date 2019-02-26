//
//  CA_MNewProjectViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MNewProjectSearchView;

@interface CA_MNewProjectViewManager : NSObject
@property (nonatomic,strong) UIButton *titleViewBtn;
@property (nonatomic,strong) UIBarButtonItem *leftBarBtn;
@property (nonatomic,strong) UIBarButtonItem *rightBarBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) CA_MNewProjectSearchView *searchView;

@property (nonatomic,copy) void(^titleBlock)(UIButton *sender);
@property (nonatomic,copy) dispatch_block_t leftBlock;
@property (nonatomic,copy) dispatch_block_t rightBlock;
@end
