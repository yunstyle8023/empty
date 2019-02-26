//
//  CA_MDiscoverSponsorItemDetailCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_MDiscoverSponsorItemInvestCell : CA_HBaseTableCell
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *type;
@property (nonatomic,strong) UILabel *typeLb;
@property (nonatomic,strong) UILabel *invest;
@property (nonatomic,strong) UILabel *investLb;
@property (nonatomic,strong) UILabel *futureMoney;
@property (nonatomic,strong) UILabel *futureMoneyLb;
@property (nonatomic,strong) UILabel *actureMoney;
@property (nonatomic,strong) UILabel *actureMoneyLb;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *lineView;
-(void)upView;
-(void)setConstraints;
-(UILabel *)create4Label;
-(UILabel *)create6Label;
@end
