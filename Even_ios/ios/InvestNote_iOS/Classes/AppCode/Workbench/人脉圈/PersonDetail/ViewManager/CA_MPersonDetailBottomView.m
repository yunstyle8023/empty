
//
//  CA_MPersonDetailBottomView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailBottomView.h"

@interface CA_MPersonDetailBottomView()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *telBtn;
@property (nonatomic,strong) UIButton *msgBtn;
@property (nonatomic,strong) UIButton *wxBtn;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@end

@implementation CA_MPersonDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = kColor(@"#FFFFFF");
    [self addSubview:self.bgView];
    [self addSubview:self.telBtn];
    [self addSubview:self.msgBtn];
    [self addSubview:self.wxBtn];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self).offset(34*CA_H_RATIO_WIDTH);
    }];
    
    [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self).offset(-34*CA_H_RATIO_WIDTH);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.telBtn.mas_trailing).offset(34*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.wxBtn.mas_leading).offset(-34*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
}

-(void)wechatAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(wechatClick)]) {
        [self.delegate wechatClick];
    }
}

-(void)mssageAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(mssageClick)]) {
        [self.delegate mssageClick];
    }
}

-(void)telBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(telClick)]) {
        [self.delegate telClick];
    }
}

#pragma mark - getter and setter
-(UIView *)rightView{
    if (_rightView) {
        return _rightView;
    }
    _rightView = [[UIView alloc] init];
    _rightView.backgroundColor = CA_H_BACKCOLOR;
    return _rightView;
}
-(UIView *)leftView{
    if (_leftView) {
        return _leftView;
    }
    _leftView = [[UIView alloc] init];
    _leftView.backgroundColor = CA_H_BACKCOLOR;
    return _leftView;
}
-(UIButton *)cretaeButotnTitle:(NSString*)title img:(NSString*)imgName sel:(SEL)sel{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button configTitle:title titleColor:CA_H_4BLACKCOLOR font:14];
    [button setImage:kImage(imgName) forState:UIControlStateNormal];
    [button setImage:kImage(imgName) forState:UIControlStateHighlighted];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(UIButton *)wxBtn{
    if (_wxBtn) {
        return _wxBtn;
    }
    _wxBtn = [self cretaeButotnTitle:@"微信" img:@"wechat" sel:@selector(wechatAction)];
    return _wxBtn;
}
-(UIButton *)msgBtn{
    if (_msgBtn) {
        return _msgBtn;
    }
    _msgBtn = [self cretaeButotnTitle:@"短信" img:@"mssage" sel:@selector(mssageAction)];
    return _msgBtn;
}
-(UIButton *)telBtn{
    if (_telBtn) {
        return _telBtn;
    }
    _telBtn = [self cretaeButotnTitle:@"电话" img:@"phone" sel:@selector(telBtnAction)];
    return _telBtn;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGRect rect = CGRectMake(0, 3, CA_H_SCREEN_WIDTH, 48*CA_H_RATIO_WIDTH-3);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = kColor(@"#FCFCFC");
    [CA_HShadow dropShadowWithView:_bgView
                            offset:CGSizeMake(0, -3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    return _bgView;
}
@end
