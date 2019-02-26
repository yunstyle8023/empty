//
//  CA_MVerifyCodeView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MVerifyCodeView.h"
#import "CA_MCaptchaView.h"

@interface CA_MVerifyCodeView ()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIView* bigContentView;
@property(nonatomic,strong)UIView* contentView;
@property(nonatomic,strong)UITextField* txtField;
@property(nonatomic,strong)CA_MCaptchaView* capchaView;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,strong)UIButton* confirmBtn;
@end

@implementation CA_MVerifyCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.bigContentView];
    [self.bigContentView addSubview:self.contentView];
    [self.contentView addSubview:self.txtField];
    [self.contentView addSubview:self.capchaView];
    [self.bigContentView addSubview:self.cancelBtn];
    [self.bigContentView addSubview:self.confirmBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(200*CA_H_RATIO_WIDTH);
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(260*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(154*CA_H_RATIO_WIDTH);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigContentView).offset(20*CA_H_RATIO_WIDTH);
        make.centerX.mas_equalTo(self.bigContentView);
        make.width.mas_equalTo(220*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(50*CA_H_RATIO_WIDTH);
    }];
    
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(140*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
    
    [self.capchaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(80*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bigContentView).offset(20);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(26*CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(100*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bigContentView).offset(-20);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(26*CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(100*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
}

-(void)showInView:(UIView*)superView{
    self.frame = superView.frame;
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)confirmAction{
    if ([NSString isValueableString:self.txtField.text]) {
        BOOL result = [[self.txtField.text lowercaseString] isEqualToString:[self.capchaView.changeString lowercaseString]];
        if (result) {
            [self cancelAction];
        }else{
            self.txtField.text = @"";
            [self.capchaView changeCaptcha];
        }
        if (self.isCorrect) {
            self.isCorrect(result);
        }
    }
}

-(void)cancelAction{
    [self removeFromSuperview];
}

#pragma mark - getter and setter
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = CA_H_TINTCOLOR;
        _confirmBtn.layer.cornerRadius = 4;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn configTitle:@"确认" titleColor:kColor(@"##FFFFFF") font:16];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = kColor(@"#FFFFFF");
        _cancelBtn.layer.borderColor = CA_H_TINTCOLOR.CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn configTitle:@"取消" titleColor:CA_H_TINTCOLOR font:16];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(CA_MCaptchaView *)capchaView{
    if (!_capchaView) {
        _capchaView = [[CA_MCaptchaView alloc] init];
    }
    return _capchaView;
}
-(UITextField *)txtField{
    if (!_txtField) {
        _txtField = [[UITextField alloc] init];
        _txtField.placeholder = @"按右图输入";
        [_txtField becomeFirstResponder];
    }
    return _txtField;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kColor(@"#FFFFFF");
        _contentView.layer.borderColor = kColor(@"#ECEDF5").CGColor;
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
-(UIView *)bigContentView{
    if (!_bigContentView) {
        _bigContentView = [[UIView alloc] init];
        _bigContentView.backgroundColor = kColor(@"#FFFFFF");
        _bigContentView.layer.cornerRadius = 8;
        _bigContentView.layer.masksToBounds = YES;
    }
    return _bigContentView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kColor(@"#04040F");
        _bgView.alpha = 0.;
    }
    return _bgView;
}


-(void)dealloc{
    NSLog(@"dealloc ------->CA_MVerifyCodeView");
}
@end
