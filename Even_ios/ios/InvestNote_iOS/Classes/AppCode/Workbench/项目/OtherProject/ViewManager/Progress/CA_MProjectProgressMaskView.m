//
//  CA_MProjectProgressMaskView.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectProgressMaskView.h"
#import "FSTextView.h"

@interface CA_MProjectProgressMaskView()
<UITextViewDelegate>
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIView* contentView;
@property(nonatomic,strong)UIView* titleBgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)FSTextView* textView;
@property(nonatomic,strong)UIButton* confirmBtn;

@end

@implementation CA_MProjectProgressMaskView

-(void)dealloc{
    [IQKeyboardManager sharedManager].enable = YES;
    NSLog(@"CA_MProjectProgressMaskView -----> dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setKeyBoard];
        [self dispatch];
    }
    return self;
}

- (void)setKeyBoard{
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)dispatch{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat y = 0;
        if (keyboardF.origin.y < CA_H_SCREEN_HEIGHT) {
            y = (CA_H_SCREEN_HEIGHT / 2) - keyboardF.size.height / 2;
        }else{
            y = CA_H_SCREEN_HEIGHT / 2;
        }
        self.contentView.centerY = y;
    }];
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleBgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.confirmBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kDevice_Is_iPhoneX?160*CA_H_RATIO_HEIGHT:160*CA_H_RATIO_WIDTH);
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(275*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(314*CA_H_RATIO_WIDTH);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleBgView);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLb.mas_bottom);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
        //
        make.width.mas_equalTo(110*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(38*CA_H_RATIO_WIDTH);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleBgView.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.contentView).offset(10);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top);
    }];
}

#pragma mark - Public

-(void)showMaskView{
    [CA_H_MANAGER.mainWindow addSubview:self];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.textView.placeholder = placeHolder;
}

-(void)setConfirmString:(NSString *)confirmString{
    _confirmString = confirmString;
    [self.confirmBtn setTitle:confirmString forState:UIControlStateNormal];
}

#pragma mark - Private

-(void)confirmBtnAction{
    if (self.confirmClick) {
        [self removeFromSuperview];
        self.confirmClick(self.textView.text);
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Getter and Setter

-(FSTextView *)textView{
    if (_textView) {
        return _textView;
    }
    _textView = [[FSTextView alloc] init];
    _textView.placeholder = @"请填写理由和备忘...";
    _textView.placeholderColor = CA_H_9GRAYCOLOR;
    _textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
    _textView.font = CA_H_FONT_PFSC_Regular(16);
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    return _textView;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    _confirmBtn = [[UIButton alloc] init];
    [_confirmBtn configTitle:@"确认进入" titleColor:kColor(@"#FFFFFF") font:15];
    _confirmBtn.backgroundColor = CA_H_TINTCOLOR;
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    _titleLb.font = CA_H_FONT_PFSC_Medium(18);
    _titleLb.textColor = CA_H_4BLACKCOLOR;
    return _titleLb;
}
-(UIView *)titleBgView{
    if (_titleBgView) {
        return _titleBgView;
    }
    _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275*CA_H_RATIO_WIDTH, 15)];
    _titleBgView.backgroundColor = kColor(@"#FFFFFF");
    [CA_HShadow dropShadowWithView:_titleBgView
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    return _titleBgView;
}
-(UIView *)contentView{
    if (_contentView) {
        return _contentView;
    }
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = kColor(@"#FFFFFF");
    _contentView.layer.cornerRadius = 10;
    _contentView.layer.masksToBounds = YES;
    _contentView.clipsToBounds = YES;
    return _contentView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#04040F");
    _bgView.alpha = 0.5;
    CA_H_WeakSelf(self)
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        CA_H_StrongSelf(self)
        [self removeFromSuperview];
    }];
    [_bgView addGestureRecognizer:tapGesture];
    return _bgView;
}
@end
