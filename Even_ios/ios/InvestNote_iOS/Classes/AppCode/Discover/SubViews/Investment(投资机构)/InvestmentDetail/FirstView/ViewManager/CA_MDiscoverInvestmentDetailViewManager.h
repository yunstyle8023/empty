//
//  CA_MDiscoverInvestmentDetailViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverInvestmentDetailHeaderView;
@class CA_MDiscoverInvestmentDetailModel;

@interface CA_MDiscoverInvestmentDetailViewManager : NSObject
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *naviView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic,strong) CA_MDiscoverInvestmentDetailHeaderView *headerView;
- (void)customNaviViewWithTarget:(id)target action:(SEL)action;
-(void)configViewWithModel:(CA_MDiscoverInvestmentDetailModel *)model
                     block:(void(^)(CGFloat height))block;
@end
