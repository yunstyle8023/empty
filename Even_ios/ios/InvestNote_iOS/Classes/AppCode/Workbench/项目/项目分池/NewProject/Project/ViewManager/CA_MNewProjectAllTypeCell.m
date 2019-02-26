
//
//  CA_MNewProjectAllTypeCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectAllTypeCell.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectAllTypeCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *countLb;
@property (nonatomic,strong) UILabel *nameLb;
@end

@implementation CA_MNewProjectAllTypeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.countLb];
    [self.contentView addSubview:self.nameLb];
}

-(void)setConstraints{
    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(5*2*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    self.countLb.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.contentView, (5+7)*2*CA_H_RATIO_WIDTH+3)
    .rightEqualToView(self.contentView)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.countLb setMaxNumberOfLinesToShow:1];
    
    self.nameLb.sd_layout
    .leftEqualToView(self.contentView)
//    .topSpaceToView(self.contentView, (5+7+15)*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.countLb).offset(20*CA_H_RATIO_WIDTH+5*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.nameLb setMaxNumberOfLinesToShow:1];
    
}

-(void)setModel:(CA_MNewProjectSplitPoolModel *)model{
    _model = model;
    self.countLb.text = [NSString stringWithFormat:@"%@",model.pool_count];
    self.nameLb.text = model.pool_name;
}

#pragma mark - getter and setter

-(UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.numberOfLines = 1;
        _nameLb.textAlignment = NSTextAlignmentCenter;
        [_nameLb configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:14];
    }
    return _nameLb;
}

-(UILabel *)countLb{
    if (!_countLb) {
        _countLb = [UILabel new];
        _countLb.numberOfLines = 1;
        _countLb.textAlignment = NSTextAlignmentCenter;
        [_countLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:22];
    }
    return _countLb;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#F8F8F8");
        _bgView.layer.cornerRadius = 4*2;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end

