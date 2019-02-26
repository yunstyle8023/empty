
//
//  CA_MMyApproveView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMyApproveView.h"

@interface CA_MMyApproveView ()
@property (nonatomic,strong) UIButton *myApproveBtn;//我审批的
@property (nonatomic,strong) UIButton *myStartBtn;//我发起的
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *currentBtn;
@end

@implementation CA_MMyApproveView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.currentBtn = self.myApproveBtn;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.myApproveBtn];
    [self addSubview:self.myStartBtn];
    [self addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
//    [super layoutSubviews];
    
    [self.myApproveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX).offset(-(20+32));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.myStartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX).offset(20+32);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.currentBtn);
//        make.leading.mas_equalTo(self.currentBtn).offset((self.currentBtn.mj_w-16)/2);
        make.top.mas_equalTo(self.currentBtn.mas_bottom).offset(3);
        //
//        make.width.mas_equalTo(16);
        make.width.mas_equalTo(self.currentBtn);
        make.height.mas_equalTo(2);
    }];
}

-(void)scroll:(CGFloat)x{
    CGFloat startX = (self.myApproveBtn.mj_x + self.myApproveBtn.width/2);
    CGFloat endX = (self.myStartBtn.mj_x + self.myApproveBtn.width/2);
    CGFloat margin = endX - startX;
    self.lineView.centerX = startX + (x/CA_H_SCREEN_WIDTH) * margin;
    UIView *line = self.lineView.subviews.firstObject;
    line.sd_layout.widthIs((1-2*fabs(x/CA_H_SCREEN_WIDTH-0.5))*(margin-16*CA_H_RATIO_WIDTH) + 16*CA_H_RATIO_WIDTH);
}

-(void)scrollDidEnd:(NSInteger)index{
    if (index == 0) {
        self.currentBtn = self.myApproveBtn;
        [self.myStartBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [self.currentBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    }else if (index == 1){
        self.currentBtn = self.myStartBtn;
        [self.myApproveBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [self.currentBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    }
}

-(void)btnAction:(UIButton*)button{
    if (self.currentBtn == button) {
        return;
    }
    
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    [self.currentBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    
    self.currentBtn = button;
    
    if (self.delegate) {
        [self.delegate didSelect:self.currentBtn==self.myApproveBtn?0:1];
    }
    
}

-(UIButton *)myStartBtn{
    if (_myStartBtn) {
        return _myStartBtn;
    }
    _myStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myStartBtn configTitle:@"我发起的" titleColor:CA_H_9GRAYCOLOR font:16];
    [_myStartBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _myStartBtn;
}

-(UIButton *)myApproveBtn{
    if (_myApproveBtn) {
        return _myApproveBtn;
    }
    _myApproveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myApproveBtn configTitle:@"我审批的" titleColor:CA_H_TINTCOLOR font:16];
    [_myApproveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _myApproveBtn;
}

-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [UIView new];
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_TINTCOLOR;
    line.layer.cornerRadius = 1*CA_H_RATIO_WIDTH;
    line.layer.masksToBounds = YES;
    [_lineView addSubview:line];
    line.sd_layout
    .heightIs(2)
    .widthIs(16*CA_H_RATIO_WIDTH)
    .centerXEqualToView(_lineView)
    .centerYEqualToView(_lineView);
    _lineView.layer.cornerRadius = 1*CA_H_RATIO_WIDTH;
    _lineView.layer.masksToBounds = YES;
    return _lineView;
}
@end
