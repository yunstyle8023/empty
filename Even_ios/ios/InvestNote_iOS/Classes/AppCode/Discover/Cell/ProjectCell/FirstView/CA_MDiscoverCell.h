//
//  CA_MDiscoverCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@class CA_MDiscoverTagView;

@interface CA_MDiscoverCell : CA_HBaseTableCell
@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CA_MDiscoverTagView *tagView;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *moneyLb;
@property (nonatomic,strong) UILabel *organizationLb;
@property (nonatomic,strong) UIView *lineView;
-(void)setConstraints;
@end
