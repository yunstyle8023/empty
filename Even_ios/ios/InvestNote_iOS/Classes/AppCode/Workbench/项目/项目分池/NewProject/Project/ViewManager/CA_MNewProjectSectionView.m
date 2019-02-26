
//
//  CA_MNewProjectSectionView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectSectionView.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectSectionView ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *arrowBtn;
@end

@implementation CA_MNewProjectSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.titleLb];
    [self addSubview:self.arrowBtn];
}

-(void)setConstraints{
    self.titleLb.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.arrowBtn.sd_layout
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(20*CA_H_RATIO_WIDTH)
    .widthIs(80*CA_H_RATIO_WIDTH);
}

-(void)setModel:(CA_MNewProjectSplitPoolListModel *)model{
    _model = model;
    self.titleLb.text = model.pool_name;;
    self.arrowBtn.hidden = NO;
}

-(void)arrowBtnAction:(UIButton *)sender{
    if (self.lookMoreBlock) self.lookMoreBlock();
}

-(UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton new];
        _arrowBtn.hidden = YES;
        [_arrowBtn setImage:kImage(@"shape2") forState:UIControlStateNormal];
        [_arrowBtn setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [_arrowBtn configTitle:@"全部" titleColor:CA_H_4BLACKCOLOR font:14];
        
        _arrowBtn.imageView.sd_resetLayout
        .widthIs(kImage(@"shape2").size.width)
        .heightIs(kImage(@"shape2").size.height)
        .centerYEqualToView(_arrowBtn.imageView.superview)
        .rightEqualToView(_arrowBtn.imageView.superview);
        
        _arrowBtn.titleLabel.sd_resetLayout
        .centerYEqualToView(_arrowBtn.titleLabel.superview)
        .rightSpaceToView(_arrowBtn.imageView, -3*2*CA_H_RATIO_WIDTH)
        .heightIs(20*CA_H_RATIO_WIDTH);
        _arrowBtn.titleLabel.numberOfLines = 1;
        [_arrowBtn.titleLabel setMaxNumberOfLinesToShow:1];
        [_arrowBtn sizeToFit];
        [_arrowBtn addTarget:self action:@selector(arrowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = CA_H_FONT_PFSC_Medium(18);
        _titleLb.textColor = CA_H_4BLACKCOLOR;
    }
    return _titleLb;
}

@end
