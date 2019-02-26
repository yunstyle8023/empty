
//
//  CA_MMyApproveCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMyApproveCell.h"
#import "CA_MMyApproveModel.h"

@interface CA_MMyApproveCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *resultLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *reasonLb;
@property (nonatomic,strong) UIView *contentsView;
@property (nonatomic,strong) UIImageView *logoView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MMyApproveCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLb];
    [self.bgView addSubview:self.resultLb];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.reasonLb];
    [self.bgView addSubview:self.contentsView];
    [self.bgView addSubview:self.logoView];
    [self.logoView addSubview:self.iconLb];
    [self.bgView addSubview:self.detailLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(200*CA_H_RATIO_WIDTH);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.bgView).offset(15);
        //
        make.width.height.mas_equalTo(20);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
    }];
    
    [self.resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
    }];

    [self.contentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLb.mas_bottom).offset(15);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(75*CA_H_RATIO_WIDTH);
    }];

    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentsView).offset(15);
        make.centerY.mas_equalTo(self.contentsView);
        //
        make.width.height.mas_equalTo(45);
    }];

    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.logoView);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.logoView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.contentsView).offset(-15);
        make.centerY.mas_equalTo(self.logoView);
    }];
}

-(void)setModel:(CA_MMyApproveModel *)model{
    [super setModel:model];
    NSString* iconStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.approval_create_user.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:iconStr] placeholder:kImage(@"head20")];
    self.titleLb.text = model.approval_create_user.chinese_name;
    self.resultLb.text = model.approval_status;
    self.resultLb.textColor = kColor(model.approval_status_color);
    self.reasonLb.text = model.approval_reason;
    if ([NSString isValueableString:model.approval_project_info.project_logo]) {
        NSString *urlStr = model.approval_project_info.project_logo;
        urlStr = ^{
            if ([urlStr hasPrefix:@"http://"]
                ||
                [urlStr hasPrefix:@"https://"]) {
                return urlStr;
            }
            return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
        }();
        [self.logoView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"loadfail_project50")];
        self.logoView.backgroundColor = kColor(@"#FFFFFF");
        //
        self.iconLb.hidden = YES;
        self.iconLb.text = @"";
    }else{
        self.logoView.image = nil;
        self.logoView.backgroundColor = kColor(model.approval_project_info.project_color);
        //
        self.iconLb.hidden = NO;
        self.iconLb.text = [model.approval_project_info.project_name substringToIndex:1];
    }
    self.detailLb.text = model.approval_title;
}

#pragma mark getter and setter
-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [UILabel new];
    [_detailLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _detailLb;
}
-(UIImageView *)logoView{
    if (_logoView) {
        return _logoView;
    }
    _logoView = [UIImageView new];
    _logoView.layer.cornerRadius = 4;
    _logoView.layer.masksToBounds = YES;
    return _logoView;
}
-(UIView *)contentsView{
    if (_contentsView) {
        return _contentsView;
    }
    _contentsView = [UIView new];
    _contentsView.backgroundColor = kColor(@"#F8F8F8");
    _contentsView.layer.cornerRadius = 2;
    _contentsView.layer.masksToBounds = YES;
    return _contentsView;
}
-(UILabel *)reasonLb{
    if (_reasonLb) {
        return _reasonLb;
    }
    _reasonLb = [UILabel new];
    [_reasonLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _reasonLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UILabel *)resultLb{
    if (_resultLb) {
        return _resultLb;
    }
    _resultLb = [UILabel new];
    [_resultLb configText:@"" textColor:nil font:14];
    return _resultLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    _titleLb.font = CA_H_FONT_PFSC_Regular(14);
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [UIImageView new];
    _iconImgView.layer.cornerRadius = 20/2;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [UIView new];
    _bgView.frame = CGRectMake(0, 0, 345*CA_H_RATIO_WIDTH, 200*CA_H_RATIO_WIDTH);
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}
@end
