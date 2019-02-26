//
//  CA_MProjectDetailNormalPersonnelCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailNormalPersonnelCollectionViewCell.h"

@interface CA_MProjectDetailNormalPersonnelCollectionViewCell()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* nickNameLb;
@property(nonatomic,strong)UILabel* positionLb;
@end

@implementation CA_MProjectDetailNormalPersonnelCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.nickNameLb];
    [self.bgView addSubview:self.positionLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.mas_equalTo(self.contentView);
    //        make.top.mas_equalTo(self.contentView);
    //        make.width.mas_equalTo(110*CA_H_RATIO_WIDTH);
    //        make.height.mas_equalTo(146*CA_H_RATIO_WIDTH);
    //    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView).offset(20);
        //
        make.width.height.mas_equalTo(50);
    }];
    
    [self.nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(10);
        make.trailing.mas_equalTo(self.bgView).offset(-10);
    }];
    
    [self.positionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.nickNameLb.mas_bottom).offset(4);
        make.leading.mas_equalTo(self.bgView).offset(10);
        make.trailing.mas_equalTo(self.bgView).offset(-10);
    }];
}

-(void)setModel:(CA_MProject_person *)model{
    _model = model;
    
    self.nickNameLb.text = model.chinese_name;
    self.positionLb.text = model.position;
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr]
                          placeholder:kImage(@"head50")];
}

-(UILabel *)positionLb{
    if (_positionLb)  {
        return _positionLb;
    }
    _positionLb = [[UILabel alloc] init];
    [_positionLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    _positionLb.textAlignment = NSTextAlignmentCenter;
    return _positionLb;
}
-(UILabel *)nickNameLb{
    if (_nickNameLb) {
        return _nickNameLb;
    }
    _nickNameLb = [[UILabel alloc] init];
    [_nickNameLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    _nickNameLb.textAlignment = NSTextAlignmentCenter;
    return _nickNameLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 50/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, (110-5)*CA_H_RATIO_WIDTH, 146*CA_H_RATIO_WIDTH)];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}
@end

