//
//  CA_MProjectDetailHistoryCell.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectDetailModel.h"

@interface CA_MProjectDetailHistoryBeginCell : UITableViewCell
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)UIView* circleView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UILabel* timeLb;
@property(nonatomic,strong)UILabel* introduceLb;
-(void)layoutSubviews;
//@property(nonatomic,strong)CA_MInvest_history* model;
-(CGFloat)configCell:(CA_MInvest_history *)model;
@end

