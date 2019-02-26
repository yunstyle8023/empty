//
//  CA_MDiscoverProjectDetailViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverProjectDetailAddView;
@class CA_MDiscoverProjectDetailHeaderView;
@class CA_MDiscoverProjectDetailModel;

@protocol CA_MDiscoverProjectDetailViewManagerDelegate <NSObject>
/**
 截图
 */
- (void)clickShotBarBtnClick;
/**
 分享
 */
- (void)clickSharBarBtnClick;
@end

@interface CA_MDiscoverProjectDetailViewManager : NSObject
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CA_MDiscoverProjectDetailModel *model;
@property (nonatomic,strong) UITableView *tableView; 
@property (nonatomic,strong) CA_MDiscoverProjectDetailAddView *addView;
@property (nonatomic,strong) CA_MDiscoverProjectDetailHeaderView *headerView;
@property (nonatomic,strong) UIButton *titleView;
@property (nonatomic,strong) UIBarButtonItem *shotBarBtnItem;
@property (nonatomic,strong) UIBarButtonItem *sharBarBtnItem;
@property (nonatomic,weak) id<CA_MDiscoverProjectDetailViewManagerDelegate> delegate;
@end
