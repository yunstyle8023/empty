//
//  CA_M_ResetPasswordVC.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MResetPasswordVC.h"
#import "CA_MUnderlineTextField.h"
#import "CA_HLoginManager.h"
#import "CA_MBandingPhoneVC.h"
#import <Bugly/Bugly.h>

typedef enum : NSUInteger {
    CA_M_Pwd_Up,
    CA_M_Pwd_Down
} CA_M_Pwd_Tag;

@interface CA_MResetPasswordVC ()
//<UITextFieldDelegate>
/// 上面的提示
@property(nonatomic,strong)UILabel* messageLb;
/// 设置新密码
@property(nonatomic,strong)CA_MUnderlineTextField* pwdTxtField;
/// 确认新密码
@property(nonatomic,strong)CA_MUnderlineTextField* confirmTxtField;
/// 最下面的提示
@property(nonatomic,strong)UILabel* tipLb;
/// 登录按钮
@property(nonatomic,strong)UIButton* loginBtn;
@end

@implementation CA_MResetPasswordVC

#pragma mark - LifeCycle

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
    [self setupUI];
    [self setConstraint];
}

//#pragma mark - UITextFieldDelegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    NSUInteger length_up = self.pwdTxtField.text.length + string.length - range.length;
//    NSUInteger length_down = self.confirmTxtField.text.length + string.length - range.length;
//    if (length_up >= 8 && length_down >= 8) {
//        self.loginBtn.enabled = YES;
//        self.loginBtn.backgroundColor = CA_H_TINTCOLOR;
//    }else{
//        self.loginBtn.enabled = NO;
//        self.loginBtn.backgroundColor = CA_H_BACKCOLOR;
//    }
//    return YES;
//}

- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    NSUInteger length_up = self.pwdTxtField.text.length;
    NSUInteger length_down = self.confirmTxtField.text.length;
    if (length_up >= 8 && length_down >= 8) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = CA_H_TINTCOLOR;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}

#pragma mark - Private

/**
 完成按钮点击事件
 */
- (void)loginBtnAction{
    [self resignFirstResponder];
    if ([self.pwdTxtField.text isEqualToString:self.confirmTxtField.text]){
        if ([self judgePassWordLegal:self.pwdTxtField.text]) {
            [self resetPwd];
        }else{
            [CA_HProgressHUD showHudStr:@"密码不符合规范" rootView:CA_H_MANAGER.loginWindow image:nil];
        }
    }else{
        [CA_HProgressHUD showHudStr:@"两次密码输入不一致" rootView:CA_H_MANAGER.loginWindow image:nil];
    }
}

/**
 重置密码
 */
- (void)resetPwd{
    NSDictionary* paramters = @{@"user_id": self.organizationId , //# 用户id 必填
                                @"new_pwd": self.pwdTxtField.text , //# 新密码 必填
                                };
    [CA_HNetManager postUrlStr:CA_M_Api_ResetNewPwd parameters:paramters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self loginAction];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
//        }
    } progress:nil];
}

- (void)loginAction{

    NSDictionary* parameters = @{@"username":self.organizationName,
                                 @"password":self.pwdTxtField.text};
    //    [CA_HProgressHUD loading:self.view];
    [CA_HLoginManager loginOrganization:parameters callBack:^(CA_HNetModel *netModel) {
        //        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess){
            if ([netModel.errcode intValue] == 0) {

                [CA_HProgressHUD showHudStr:@"登录成功!" rootView:CA_H_MANAGER.mainWindow image:nil];
                
                //保存是否绑定了手机号
                [CA_H_MANAGER saveBingdPhoneNumber:[netModel.data[@"phone_bind_count"] boolValue]];
                [CA_H_MANAGER saveUserWeChat:[netModel.data[@"wechat_bind_count"] boolValue]];

                if ([netModel.data[@"phone_bind_count"] intValue]==0) {
                    CA_MBandingPhoneVC* bandingVC = [[CA_MBandingPhoneVC alloc] init];
                    bandingVC.userName = netModel.data[@"user_data"][@"chinese_name"];
                    [self.navigationController pushViewController:bandingVC animated:YES];
                }else {
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:CA_H_ShareDataNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshWorkbenchNotification object:nil];
                    //退出登录页面
                    [CA_H_MANAGER hideLoginWindow:YES];
                    //存储用户信息
                    [Bugly setUserIdentifier:netModel.data[@"user_data"][@"chinese_name"]];
                    [CA_H_MANAGER setUserPhone:netModel.data[@"user_phone"]];
                    [CA_H_MANAGER setUserName:netModel.data[@"user_data"][@"chinese_name"]];
                    [CA_H_MANAGER setUserId:netModel.data[@"user_data"][@"user_id"]];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
            }
        }else{
            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
        }
    }];
    
}

/**
 判断密码长度大于8位且同时包含数字和字符
 
 @param pass <#pass description#>
 @return <#return value description#>
 */
- (BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8){
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

/**
 添加控件
 */
- (void)setupUI{
    [self.view addSubview:self.messageLb];
    [self.view addSubview:self.pwdTxtField];
    [self.view addSubview:self.confirmTxtField];
    [self.view addSubview:self.tipLb];
    [self.view addSubview:self.loginBtn];
}

/**
 添加控件约束
 */
- (void)setConstraint{
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(30 * CA_H_RATIO_WIDTH);
        make.leading.mas_equalTo(self.view).offset(20);
    }];
    
    [self.pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.messageLb.mas_bottom).offset(30);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.confirmTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.pwdTxtField.mas_bottom).offset(20);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.confirmTxtField.mas_bottom).offset(10);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.confirmTxtField);
        make.top.mas_equalTo(self.tipLb.mas_bottom).offset(50 * CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.confirmTxtField);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
}


- (void)setTextField:(CA_MUnderlineTextField*)textField  title:(NSString*)title tag:(CA_M_Pwd_Tag)tag sel:(SEL)sel{
    //
    textField.font = CA_H_FONT_PFSC_Regular(20);
    textField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(20) range:NSMakeRange(0, attStr.length)];
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
    button.selected = !button.isSelected;
    if (button.isSelected) {
        if (button.tag == CA_M_Pwd_Up) {
            self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
            [self.pwdTxtField becomeFirstResponder];
        }else{
            self.confirmTxtField.secureTextEntry = !self.confirmTxtField.isSecureTextEntry;
            [self.confirmTxtField becomeFirstResponder];
        }
    }else{
        if (button.tag == CA_M_Pwd_Up) {
            self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
            [self.pwdTxtField becomeFirstResponder];
        }else{
            self.confirmTxtField.secureTextEntry = !self.confirmTxtField.isSecureTextEntry;
            [self.confirmTxtField becomeFirstResponder];
        }
    }
}

#pragma mark - Getter and Setter
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn configTitle:@"重置密码并登录" titleColor:kColor(@"#FFFFFF") font:18];
        _loginBtn.backgroundColor = CA_H_BACKCOLOR;
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}
-(CA_MUnderlineTextField *)confirmTxtField{
    if (_confirmTxtField) {
        return _confirmTxtField;
    }
    _confirmTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_confirmTxtField title:@"请再次确认新密码" tag:CA_M_Pwd_Down sel:@selector(eyeAction:)];
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
    [self setTextField:_pwdTxtField title:@"请设置新密码" tag:CA_M_Pwd_Up sel:@selector(eyeAction:)];
//    _pwdTxtField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_pwdTxtField];
    return _pwdTxtField;
}
-(UILabel *)messageLb{
    if (_messageLb) {
        return _messageLb;
    }
    _messageLb = [[UILabel alloc] init];
    [_messageLb configText:@"设置密码" textColor:CA_H_4BLACKCOLOR font:28];
    return _messageLb;
}
-(UILabel *)tipLb{
    if (_tipLb) {
        return _tipLb;
    }
    _tipLb = [[UILabel alloc] init];
    [_tipLb configText:@"密码至少需要8个字符，而且需同时包含字母和数字。"
             textColor:CA_H_9GRAYCOLOR font:14];
    _tipLb.numberOfLines = 0;
    return _tipLb;
}
@end
