//
//  CA_MDiscoverInvestmentDetailHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CA_MDiscoverInvestmentDetailModel;

@interface CA_MDiscoverInvestmentDetailHeaderView : UIView
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *introLb;
-(void)configViewWithModel:(CA_MDiscoverInvestmentDetailModel *)model
                     block:(void(^)(CGFloat height))block;
@end
