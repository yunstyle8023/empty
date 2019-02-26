
//
//  CA_MDiscoverSponsorDetailItemViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailItemViewCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailItemViewCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *countLb;
@end

@implementation CA_MDiscoverSponsorDetailItemViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstrains];
    }
    return self;
}

-(void)upView{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.countLb];
    [self.contentView addSubview:self.titleLb];
}

-(void)setConstrains{
    
    self.bgView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .widthIs(38*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.sloganImgView.sd_layout
    .centerXEqualToView(self.bgView)
    .centerYEqualToView(self.bgView)
    .widthIs(20*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.countLb.sd_layout
    .rightSpaceToView(self.contentView, 4*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 3*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.countLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.titleLb.sd_layout
    .centerXEqualToView(self.bgView)
    .topSpaceToView(self.bgView, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:2];
}

-(void)setModel:(CA_MDiscoverSponsorLp_moudle *)model{
    _model = model;
    
    [self.sloganImgView setImageURL:[NSURL URLWithString:model.module_logo]];
    
    if (model.total_count.intValue == 0) {
        self.countLb.textColor = kColor(@"#CCCCCC");
    }else {
        self.countLb.textColor = CA_H_TINTCOLOR;
    }
    
    self.countLb.text = [NSString stringWithFormat:@"%@",model.total_count];
    
    self.titleLb.text = model.module_name;
}

#pragma mark - getter and setter
-(UILabel *)countLb{
    if (!_countLb) {
        _countLb = [UILabel new];
        [_countLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:12];
    }
    return _countLb;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.numberOfLines = 2;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:14];
    }
    return _titleLb;
}
-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _sloganImgView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = kColor(@"#F8F8F8");
    }
    return _bgView;
}

@end
