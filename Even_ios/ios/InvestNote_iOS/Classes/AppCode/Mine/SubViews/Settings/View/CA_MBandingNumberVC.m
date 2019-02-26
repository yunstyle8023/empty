
//
//  CA_MBandingNumberVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MBandingNumberVC.h"
#import "CA_MCountdownBtn.h"
#import "CA_MVertificationCodeView.h"

@interface CA_MBandingNumberVC ()
<VertificationCodeViewDelegate,
UITextFieldDelegate,
CA_MCountdownBtnDelegate>
{
    NSString* previousTextFieldContent;
    UITextRange* previousSelection;
}

@property(nonatomic,strong)UILabel* countryLb;
@property (nonatomic,strong) UITextField *txtField;
@property(nonatomic,strong)CA_MCountdownBtn* countdownBtn;
@property (nonatomic,strong) UIView *lineView;
@property(nonatomic,strong)CA_MVertificationCodeView* verificationCodeView;
@property(nonatomic,strong)UIButton* bandingBtn;
@end

@implementation CA_MBandingNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navigationTitle;
    [self setupUI];
    [self setConstraint];
}

- (void)setupUI{
    [self.view addSubview:self.countryLb];
    [self.view addSubview:self.txtField];
    [self.view addSubview:self.countdownBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.verificationCodeView];
    [self.view addSubview:self.bandingBtn];
}

- (void)setConstraint{
    [self.countryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(20);
    }];
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.countryLb);
        make.leading.mas_equalTo(self.countryLb.mas_trailing).offset(5);
    }];
    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.centerY.mas_equalTo(self.countryLb);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryLb);
        make.trailing.mas_equalTo(self.countdownBtn);
        make.top.mas_equalTo(self.countryLb.mas_bottom).offset(16);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.lineView.mas_bottom);//.offset(66);
        make.height.mas_equalTo(66);
    }];
    [self.bandingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.verificationCodeView.mas_bottom).offset(50);
        make.height.mas_equalTo(48);
    }];
}

-(void)bandingAction{

    NSDictionary * parameters = @{@"phone": [self.txtField.text stringByReplacingOccurrencesOfString:@" " withString:@""] , //# 必填
                                  @"verify_code": self.verificationCodeView.vertificationCode , //# 必填 验证码
                                  };
//
        [CA_HNetManager postUrlStr:CA_M_Api_ValidPhoneBindCode parameters:parameters callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    //
                    [CA_H_MANAGER setUserPhone:[self.txtField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if (self.block) {
                        self.block();
                    }
                    
                }else{
                    [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                }
            }
//            else{
//                [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
//            }
        } progress:nil];
    
}

#pragma mark - VertificationCodeViewDelegate
- (void)didFinishVertificationCode:(NSString*)vertificationCode{
    if ([NSString isValueableString:self.txtField.text]) {
        self.bandingBtn.enabled = YES;
        self.bandingBtn.backgroundColor = CA_H_TINTCOLOR;
    }else{
        self.bandingBtn.enabled = NO;
        self.bandingBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}

- (void)deleteVertificationCode:(NSString*)vertificationCode{
    self.bandingBtn.enabled = NO;
    self.bandingBtn.backgroundColor = CA_H_BACKCOLOR;
}

#pragma mark - CA_MCountdownBtnDelegate

-(void)startCount{
    self.txtField.enabled = NO;
    [self.verificationCodeView becomeFirstResponder];
}

-(void)didEndCount{
    self.txtField.enabled = YES;
}

- (void)getVerifyCode{
    NSDictionary *parameters = @{@"phone":[self.txtField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};
    [CA_HNetManager postUrlStr:CA_M_Api_GenPhoneBind parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self.countdownBtn startCountDown];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = textField.text.length + string.length - range.length;
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    if (length >= 13){
        self.countdownBtn.enabled = YES;
        [self.countdownBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    }else{
        self.countdownBtn.enabled = NO;
        [self.countdownBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    }
    return length <= 13;
}

/**
 实现手机号码格式化 344(xxx xxxx xxxx)
 
 @param textField textField description
 */
- (void)textFieldEditingChanged:(UITextField *)textField{
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }else {
        editFlag = 1;
    }
    NSMutableString *tempStr = [NSMutableString new];
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length <12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    textField.text = tempStr;
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
}
#pragma mark - Getter and Setter
-(UILabel *)countryLb{
    if (_countryLb) {
        return _countryLb;
    }
    _countryLb = [[UILabel alloc] init];
    [_countryLb configText:[NSString stringWithFormat:@"+86"] textColor:CA_H_4BLACKCOLOR font:16];
    return _countryLb;
}
-(UITextField *)txtField{
    if (_txtField) {
        return _txtField;
    }
    _txtField = [[UITextField alloc] init];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号码"];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, attrString.length)];
    _txtField.attributedPlaceholder = attrString;
    _txtField.textColor = CA_H_4BLACKCOLOR;
    _txtField.font = CA_H_FONT_PFSC_Regular(16);
    _txtField.keyboardType = UIKeyboardTypeNumberPad;
    _txtField.delegate = self;
    [_txtField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    return _txtField;
}
-(CA_MCountdownBtn *)countdownBtn{
    if (_countdownBtn) {
        return _countdownBtn;
    }
    _countdownBtn = [[CA_MCountdownBtn alloc] init];
    _countdownBtn.isVerificationCode = NO;
    _countdownBtn.delegate = self;
    [_countdownBtn configTitle:@"发送验证码" titleColor:CA_H_9GRAYCOLOR font:16];
    _countdownBtn.enabled = NO;
    return _countdownBtn;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [UIView new];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(CA_MVertificationCodeView *)verificationCodeView{
    if (_verificationCodeView) {
        return _verificationCodeView;
    }
    _verificationCodeView = [[CA_MVertificationCodeView alloc] init];
    _verificationCodeView.delegate = self;
    _verificationCodeView.secureTextEntry = NO;
    return _verificationCodeView;
}
-(UIButton *)bandingBtn{
    if (_bandingBtn) {
        return _bandingBtn;
    }
    _bandingBtn = [[UIButton alloc] init];
    [_bandingBtn configTitle:self.buttonTitle titleColor:kColor(@"#FFFFFF") font:18];
    _bandingBtn.backgroundColor = CA_H_BACKCOLOR;
    _bandingBtn.layer.cornerRadius = 4;
    _bandingBtn.layer.masksToBounds = YES;
    _bandingBtn.enabled = NO;
    [_bandingBtn addTarget:self action:@selector(bandingAction) forControlEvents:UIControlEventTouchUpInside];
    return _bandingBtn;
}
@end
