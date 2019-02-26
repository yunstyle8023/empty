//
//  CA_MNewProjectContentViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MProjectMemberView;
@class CA_MProjectContentSelectView;
@class CA_MProjectContentScrollView;

@interface CA_MNewProjectContentViewManager : NSObject

@property (nonatomic,strong) NSNumber *pId;

@property(nonatomic,strong) UIBarButtonItem *memberItem;

@property(nonatomic,strong) UIBarButtonItem *settingItem;

@property (nonatomic,strong) NSMutableArray<UIBarButtonItem *> *barButtonItems;

@property (nonatomic,copy) dispatch_block_t memberBlock;

@property (nonatomic,copy) dispatch_block_t settingBlock;

@property (nonatomic,strong) CA_MProjectMemberView *memberView;

@property (nonatomic,strong) CA_MProjectContentSelectView *topView;

@property (nonatomic,strong) CA_MProjectContentScrollView *scrollView;

@end
