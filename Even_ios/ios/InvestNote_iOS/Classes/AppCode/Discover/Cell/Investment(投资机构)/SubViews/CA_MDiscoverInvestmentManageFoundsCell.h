//
//  CA_MDiscoverInvestmentManageFoundsCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"
@class ButtonLabel;
@interface CA_MDiscoverInvestmentManageFoundsCell : CA_HBaseTableCell
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) ButtonLabel *titleLb;
@property (nonatomic,strong) UILabel *legal;
@property (nonatomic,strong) ButtonLabel *legalLb;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UILabel *moneyLb;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *lineView;
-(void)setupView;
-(void)setConstrains;
@end
