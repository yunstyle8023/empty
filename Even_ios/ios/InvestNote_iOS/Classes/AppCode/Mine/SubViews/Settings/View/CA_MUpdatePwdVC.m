

//
//  CA_MUpdatePwdVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MUpdatePwdVC.h"
#import "CA_MUnderlineTextField.h"
#import "CA_MBandingNumberVC.h"

typedef enum : NSUInteger {
    CA_M_Pwd_Old,
    CA_M_Pwd_New,
    CA_M_Pwd_Confirm
} CA_M_Pwd_Tag;

@interface CA_MUpdatePwdVC ()
//<UITextFieldDelegate>

@property(nonatomic,strong)CA_MUnderlineTextField* oldTxtField;
@property(nonatomic,strong)CA_MUnderlineTextField* pwdTxtField;
@property(nonatomic,strong)CA_MUnderlineTextField* confirmTxtField;
@property(nonatomic,strong)UILabel* tipLb;
@property (nonatomic,strong) UIButton *vertifiBtn;
@property (nonatomic,strong) UIButton *forgetPwdBtn;
@end

@implementation CA_MUpdatePwdVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self setupUI];
    [self setConstraint];
}

-(void)setupUI{
    [self.view addSubview:self.oldTxtField];
    [self.view addSubview:self.pwdTxtField];
    [self.view addSubview:self.confirmTxtField];
    [self.view addSubview:self.tipLb];
    [self.view addSubview:self.vertifiBtn];
    [self.view addSubview:self.forgetPwdBtn];
}

-(void)setConstraint{
    [self.oldTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(4);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(54);
    }];
    [self.pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldTxtField.mas_bottom);//.offset(4);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(54);
    }];
    [self.confirmTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdTxtField.mas_bottom);//.offset(4);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(54);
    }];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmTxtField.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
    }];
    [self.vertifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLb.mas_bottom).offset(40);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(48);
    }];
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.vertifiBtn.mas_bottom).offset(16);
        make.leading.mas_equalTo(self.view).offset(20);
    }];
}


#pragma mark - UITextFieldDelegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    int length_old = self.oldTxtField.text.length + string.length - range.length;
//    int length_pwd = self.pwdTxtField.text.length + string.length - range.length;
//    int length_confirm = self.confirmTxtField.text.length + string.length - range.length;
//    if ((length_old >= 20)||
//        (length_pwd >= 20)||
//        (length_confirm >= 20)) {
//        [CA_HProgressHUD showHudStr:@"密码不能大于20位数，请重新输入"];
//        return NO;
//    }
//    if (length_old > 5 && length_pwd > 5 && length_confirm > 5) {
//        self.vertifiBtn.enabled = YES;
//        self.vertifiBtn.backgroundColor = CA_H_TINTCOLOR;
//    }else{
//        self.vertifiBtn.enabled = NO;
//        self.vertifiBtn.backgroundColor = CA_H_BACKCOLOR;
//    }
//    return YES;
//}

- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    int length_pwd = self.pwdTxtField.text.length;
    int length_confirm = self.confirmTxtField.text.length;
    if ((length_pwd >= 20)||
        (length_confirm >= 20)) {
        [CA_HProgressHUD showHudStr:@"密码不能大于20位数，请重新输入"];
    }
    if (length_pwd >= 8 && length_confirm >= 8) {
        self.vertifiBtn.enabled = YES;
        self.vertifiBtn.backgroundColor = CA_H_TINTCOLOR;
    }else{
        self.vertifiBtn.enabled = NO;
        self.vertifiBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}

//- (BOOL)judgePassWordLegal:(NSString *)pass{
//    BOOL result = false;
//    if ([pass length] >= 8){
//        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        result = [pred evaluateWithObject:pass];
//    }
//    return result;
//}

-(void)vertifiBtnAction{
    
    if (![self.pwdTxtField.text isEqualToString:self.confirmTxtField.text]) {
        [CA_HProgressHUD showHudStr:@"两次新密码不同，请重新输入"];
        return;
    }
    
    NSDictionary* parameters = @{ @"password": self.oldTxtField.text,               //# 原密码(必填)
                                  @"new_password": self.pwdTxtField.text            //# 新密码(必填)
                                  };
    [CA_HNetManager postUrlStr:CA_M_Api_ChangePassword parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [CA_HProgressHUD showHudStr:@"密码修改成功"];
                //更新本地保存的密码
                NSDictionary* accountStr =  [CA_H_UserDefaults objectForKey:NSLoginAccount];
                NSDictionary* parameters = @{@"username": accountStr[@"username"],
                                             @"password": self.pwdTxtField.text};
                [CA_H_UserDefaults setObject:parameters forKey:NSLoginAccount];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

-(void)forgetPwdBtnAction{
    CA_MBandingNumberVC* bandingNumberVC = [CA_MBandingNumberVC new];
    bandingNumberVC.navigationTitle = @"验证身份";
    bandingNumberVC.buttonTitle = @"提交";
    [self.navigationController pushViewController:bandingNumberVC animated:YES];
}

#pragma mark - Getter and Setter
- (void)setTextField:(CA_MUnderlineTextField*)textField  title:(NSString*)title tag:(CA_M_Pwd_Tag)tag sel:(SEL)sel{
    //
    textField.font = CA_H_FONT_PFSC_Regular(16);
    textField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, attStr.length)];
    textField.attributedPlaceholder = attStr;
    //
    textField.secureTextEntry = YES;
    textField.tag = tag;
    //
    UIButton* eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    eyeBtn.tag = tag;
    eyeBtn.selected = NO;
    [eyeBtn setImage:kImage(@"icons_eyes_off") forState:UIControlStateNormal];
    [eyeBtn setImage:kImage(@"icons_eyes_on") forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = eyeBtn;
    textField.rightViewMode = UITextFieldViewModeAlways;
}
- (void)eyeAction:(UIButton*)button{
//    button.selected = !button.isSelected;
//    if (button.tag == CA_M_Pwd_Old) {
        UIButton* oldBtn = (UIButton*)self.oldTxtField.rightView;
        oldBtn.selected = !oldBtn.isSelected;
        self.oldTxtField.secureTextEntry = !self.oldTxtField.isSecureTextEntry;
        [self.oldTxtField becomeFirstResponder];
//    }else if (button.tag == CA_M_Pwd_New) {
        UIButton* pwdBtn = (UIButton*)self.pwdTxtField.rightView;
        pwdBtn.selected = !pwdBtn.isSelected;
        self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
        [self.pwdTxtField becomeFirstResponder];
//    }else if (button.tag == CA_M_Pwd_Confirm) {
        UIButton* confirmBtn = (UIButton*)self.confirmTxtField.rightView;
        confirmBtn.selected = !confirmBtn.isSelected;
        self.confirmTxtField.secureTextEntry = !self.confirmTxtField.isSecureTextEntry;
        [self.confirmTxtField becomeFirstResponder];
//    }
}
-(UIButton *)forgetPwdBtn{
    if (_forgetPwdBtn) {
        return _forgetPwdBtn;
    }
    _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetPwdBtn configTitle:@"忘记密码？" titleColor:CA_H_TINTCOLOR font:14];
    [_forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _forgetPwdBtn.hidden = YES;//暂时隐藏掉 忘记就忘记吧
    return _forgetPwdBtn;
}
-(UIButton *)vertifiBtn{
    if (_vertifiBtn) {
        return _vertifiBtn;
    }
    _vertifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_vertifiBtn configTitle:@"验证身份" titleColor:kColor(@"#FFFFFF") font:18];
    _vertifiBtn.layer.cornerRadius = 2;
    _vertifiBtn.layer.masksToBounds = YES;
    _vertifiBtn.backgroundColor = CA_H_BACKCOLOR;
    _vertifiBtn.enabled = NO;
    [_vertifiBtn addTarget:self action:@selector(vertifiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _vertifiBtn;
}
-(CA_MUnderlineTextField *)confirmTxtField{
    if (_confirmTxtField) {
        return _confirmTxtField;
    }
    _confirmTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_confirmTxtField title:@"请再次确认新密码" tag:CA_M_Pwd_Confirm sel:@selector(eyeAction:)];
//    _confirmTxtField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_confirmTxtField];
    return _confirmTxtField;
}
-(CA_MUnderlineTextField *)pwdTxtField{
    if (_pwdTxtField) {
        return _pwdTxtField;
    }
    _pwdTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_pwdTxtField title:@"请设置新密码" tag:CA_M_Pwd_New sel:@selector(eyeAction:)];
//    _pwdTxtField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_pwdTxtField];
    return _pwdTxtField;
}
-(CA_MUnderlineTextField *)oldTxtField{
    if (_oldTxtField) {
        return _oldTxtField;
    }
    _oldTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_oldTxtField title:@"请输入旧密码" tag:CA_M_Pwd_Old sel:@selector(eyeAction:)];
//    _oldTxtField.delegate = self;
    return _oldTxtField;
}
-(UILabel *)tipLb{
    if (_tipLb) {
        return _tipLb;
    }
    _tipLb = [[UILabel alloc] init];
    [_tipLb configText:@"密码至少需要8个字符，而且需同时包含字母和数字。"
             textColor:kColor(@"#999999") font:14];
    _tipLb.numberOfLines = 0;
    return _tipLb;
}
@end
