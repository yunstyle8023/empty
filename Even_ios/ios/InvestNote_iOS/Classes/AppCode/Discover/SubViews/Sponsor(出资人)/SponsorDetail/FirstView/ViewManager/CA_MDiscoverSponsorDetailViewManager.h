//
//  CA_MDiscoverSponsorDetailViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverSponsorDetailHeaderView;
@class CA_MDiscoverSponsorDetailBottomView;
@class CA_MDiscoverSponsorDetailContactView;
@class CA_MDiscoverSponsorDetailModel;

@interface CA_MDiscoverSponsorDetailViewManager : NSObject
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *naviView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic,strong) CA_MDiscoverSponsorDetailHeaderView *headerView;
@property (nonatomic,strong) CA_MDiscoverSponsorDetailBottomView *bottomView;
@property (nonatomic,strong) CA_MDiscoverSponsorDetailContactView *contactView;
-(void)configViewManager:(CA_MDiscoverSponsorDetailModel *)model block:(void(^)(CGFloat height))block;
-(void)customNaviViewWithTarget:(id)target action:(SEL)action;
@end
