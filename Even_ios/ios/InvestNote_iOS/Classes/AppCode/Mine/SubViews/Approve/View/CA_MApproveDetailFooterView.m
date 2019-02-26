
//
//  CA_MApproveDetailFooterView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveDetailFooterView.h"

@interface CA_MApproveDetailFooterView ()
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIButton *rejectBtn;
@property (nonatomic,strong) UIButton *passBtn;
@end

@implementation CA_MApproveDetailFooterView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.agreeBtn];
    [self addSubview:self.rejectBtn];
    [self addSubview:self.passBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-40)/3);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-40)/3);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).offset(-10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-40)/3);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
}

-(void)agreeBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(operationClick:)]) {
        [self.delegate operationClick:1];
    }
}

-(void)rejectBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(operationClick:)]) {
        [self.delegate operationClick:2];
    }
}

-(void)passBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(operationClick:)]) {
        [self.delegate operationClick:3];
    }
}

#pragma mark - getter and setter
-(UIButton *)passBtn{
    if (_passBtn) {
        return _passBtn;
    }
    _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_passBtn configTitle:@"弃权" titleColor:kColor(@"#FFFFFF") font:15];
    _passBtn.backgroundColor = [UIColor blackColor];
    _passBtn.layer.cornerRadius = 4;
    _passBtn.layer.masksToBounds = YES;
    [_passBtn addTarget:self action:@selector(passBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _passBtn;
}
-(UIButton *)rejectBtn{
    if (_rejectBtn) {
        return _rejectBtn;
    }
    _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rejectBtn configTitle:@"驳回" titleColor:kColor(@"#FFFFFF") font:15];
    _rejectBtn.backgroundColor = kColor(@"#DC5656");
    _rejectBtn.layer.cornerRadius = 4;
    _rejectBtn.layer.masksToBounds = YES;
    [_rejectBtn addTarget:self action:@selector(rejectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _rejectBtn;
}

-(UIButton *)agreeBtn{
    if (_agreeBtn) {
        return _agreeBtn;
    }
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn configTitle:@"通过" titleColor:kColor(@"#FFFFFF") font:15];
    _agreeBtn.backgroundColor = CA_H_TINTCOLOR;
    _agreeBtn.layer.cornerRadius = 4;
    _agreeBtn.layer.masksToBounds = YES;
    [_agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _agreeBtn;
}
@end
