//
//  CA_M_OrganizationLoginVC.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MOrganizationLoginVC.h"
#import "CA_MUnderlineTextField.h"
#import "CA_MPhoneLoginVC.h"
#import "CA_MTryVC.h"
#import "CA_MTryH5VC.h"
#import "CA_MForgetPwdVC.h"
#import "CA_MBandingPhoneVC.h"
#import "CA_MNavigationController.h"
#import "CA_HLoginManager.h"
#import <Bugly/Bugly.h>
#import "CA_HAppManager+Account.h"
#import "CA_MSettingProjectVC.h"
#import "CA_MChangeWorkSpace.h"
#import "CA_HHomePageViewController.h"

typedef enum : NSUInteger {
    CA_M_OrganizationTag_Name,
    CA_M_OrganizationTag_Pwd
} CA_M_OrganizationTag;

@interface CA_MOrganizationLoginVC ()
<UITextFieldDelegate>

/// 机构账号登录
@property(nonatomic,strong)UILabel* organizationLb;
/// 机构账号
@property(nonatomic,strong)CA_MUnderlineTextField* nameTxtField;
/// 密码
@property(nonatomic,strong)CA_MUnderlineTextField* pwdTxtField;
/// 账号登录
@property(nonatomic,strong)UIButton* phoneBtn;
/// 小箭头
@property(nonatomic,strong)UIImageView* arrowImgView;
/// 注册
@property(nonatomic,strong)UIButton* registerBtn;
/// 忘记密码
@property(nonatomic,strong)UIButton* moreBtn;
/// 登录按钮
@property(nonatomic,strong)UIButton* loginBtn;
@end

@implementation CA_MOrganizationLoginVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];;
    [self setupUI];
    [self setupConstraint];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate

#pragma mark - Private

/**
 添加控件
 */
- (void)setupUI{
    [self.view addSubview:self.organizationLb];
    [self.view addSubview:self.nameTxtField];
    [self.view addSubview:self.pwdTxtField];
    [self.view addSubview:self.phoneBtn];
    [self.view addSubview:self.arrowImgView];
    [self.view addSubview:self.moreBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loginBtn];
}

/**
 添加控件约束
 */
- (void)setupConstraint{
    [self.organizationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30 * CA_H_RATIO_WIDTH);
    }];
    
    [self.nameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.organizationLb);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.organizationLb.mas_bottom).offset(30);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.organizationLb);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.nameTxtField.mas_bottom).offset(20);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.pwdTxtField);
        make.top.mas_equalTo(self.pwdTxtField.mas_bottom).offset(20);
    }];

    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneBtn.mas_trailing);
        make.centerY.mas_equalTo(self.phoneBtn);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.pwdTxtField);
        make.centerY.mas_equalTo(self.phoneBtn);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.moreBtn.mas_leading).offset(-10*2*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self.moreBtn);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.pwdTxtField);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(50 * CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.pwdTxtField);
        make.height.mas_equalTo(48 * CA_H_RATIO_WIDTH);
    }];
}

- (void)phoneBtnAction{
    CA_MPhoneLoginVC* phoneLoginVC = [[CA_MPhoneLoginVC alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

-(void)registerBtnAction{
    CA_MForgetPwdVC* forgetVC = [[CA_MForgetPwdVC alloc] init];
    forgetVC.titleStr = @"创建机构";
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)moreBtnAction{
    
    CA_MForgetPwdVC* forgetVC = [[CA_MForgetPwdVC alloc] init];
    forgetVC.titleStr = @"请输入账号";
    [self.navigationController pushViewController:forgetVC animated:YES];
    
    
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"申请试用" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        CA_MTryH5VC* tryVC = [[CA_MTryH5VC alloc] init];
//        [self.navigationController pushViewController:tryVC animated:YES];
//    }];
//
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        CA_MForgetPwdVC* forgetVC = [[CA_MForgetPwdVC alloc] init];
//        [self.navigationController pushViewController:forgetVC animated:YES];
//    }];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
////    隐藏申请试用功能 by hyz
////    [actionSheet addAction:addPhoneAction];
//
//    [actionSheet addAction:photoAction];
//    [actionSheet addAction:cancelAction];
//    [self presentViewController:actionSheet animated:true completion:nil];
}

#pragma mark - UITextFieldDelegate

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == CA_M_OrganizationTag_Name) {
        self.nameTxtField.underLineColor = CA_H_TINTCOLOR;
    }else if (textField.tag == CA_M_OrganizationTag_Pwd) {
        self.pwdTxtField.underLineColor = CA_H_TINTCOLOR;
    }
    return YES;
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == CA_M_OrganizationTag_Name) {
        self.nameTxtField.underLineColor = CA_H_BACKCOLOR;
    }else if (textField.tag == CA_M_OrganizationTag_Pwd) {
        self.pwdTxtField.underLineColor = CA_H_BACKCOLOR;
    }
}

/**
 监听textField每一次值得变化

 @param txtField <#txtField description#>
 */
- (void)textFieldChanged:(CA_MUnderlineTextField*)txtField{
    if (self.nameTxtField.text.length >0 && self.pwdTxtField.text.length > 0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = CA_H_TINTCOLOR;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}

/**
 登录事件
 */
- (void)loginAction{
    [self.nameTxtField resignFirstResponder];
    [self.pwdTxtField resignFirstResponder];
    
    NSDictionary* parameters = @{@"username":self.nameTxtField.text,
                                 @"password":self.pwdTxtField.text};
    [CA_HProgressHUD showHud:CA_H_MANAGER.loginWindow text:@"登录中"];
    [CA_HLoginManager loginOrganization:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:CA_H_MANAGER.loginWindow animated:NO];
        if (netModel.type == CA_H_NetTypeSuccess){
            if ([netModel.errcode intValue] == 0) {

                //保存是否绑定了手机号
                [CA_H_MANAGER saveBingdPhoneNumber:[netModel.data[@"phone_bind_count"] boolValue]];
                [CA_H_MANAGER saveUserWeChat:[netModel.data[@"wechat_bind_count"] boolValue]];
                
                if ([netModel.data[@"phone_bind_count"] intValue]==0) {
                    CA_MBandingPhoneVC* bandingVC = [[CA_MBandingPhoneVC alloc] init];
                    bandingVC.userName = netModel.data[@"user_data"][@"chinese_name"];
                    [self.navigationController pushViewController:bandingVC animated:YES];
                }else {
                    [CA_HProgressHUD showHudStr:@"登录成功!" rootView:CA_H_MANAGER.mainWindow image:nil];
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
                self.pwdTxtField.text = @"";
                [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
//        }
    }];

}


- (void)eyeAction:(UIButton*)button{
    button.selected = !button.isSelected;
    self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
    [self.pwdTxtField becomeFirstResponder];
}
        
#pragma mark - Getter and Setter

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        [_registerBtn configTitle:@"注册"
                   titleColor:CA_H_TINTCOLOR
                         font:14];
        [_registerBtn addTarget:self
                     action:@selector(registerBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)moreBtn{
    if (_moreBtn) {
        return _moreBtn;
    }
    _moreBtn = [[UIButton alloc] init];
    [_moreBtn configTitle:@"忘记密码"
               titleColor:CA_H_TINTCOLOR
                     font:14];
    [_moreBtn addTarget:self
                 action:@selector(moreBtnAction)
       forControlEvents:UIControlEventTouchUpInside];
    return _moreBtn;
}
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"icons_Details");
    return _arrowImgView;
}
- (UIButton *)phoneBtn{
    if (_phoneBtn) {
        return _phoneBtn;
    }
    _phoneBtn = [[UIButton alloc] init];
    [_phoneBtn configTitle:@"手机号登录"
                titleColor:CA_H_TINTCOLOR
                      font:14];
    [_phoneBtn addTarget:self
                  action:@selector(phoneBtnAction)
        forControlEvents:UIControlEventTouchUpInside];
    return _phoneBtn;
}
-(UIButton *)loginBtn{
    if (_loginBtn) {
        return _loginBtn;
    }
    _loginBtn = [[UIButton alloc] init];
    [_loginBtn configTitle:@"登录"
                titleColor:kColor(@"#FFFFFF")
                      font:18];
    _loginBtn.backgroundColor = CA_H_BACKCOLOR;
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.enabled = NO;
    [_loginBtn addTarget:self
                  action:@selector(loginAction)
        forControlEvents:UIControlEventTouchUpInside];
    return _loginBtn;
}
-(CA_MUnderlineTextField *)pwdTxtField{
    if (_pwdTxtField) {
        return _pwdTxtField;
    }
    _pwdTxtField = [[CA_MUnderlineTextField alloc] init];
    _pwdTxtField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:CA_H_9GRAYCOLOR
                   range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName
                   value:CA_H_FONT_PFSC_Regular(20)
                   range:NSMakeRange(0, attStr.length)];
    _pwdTxtField.attributedPlaceholder = attStr;
    _pwdTxtField.font = CA_H_FONT_PFSC_Regular(20);
    _pwdTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTxtField.secureTextEntry = YES;
    [_pwdTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_pwdTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _pwdTxtField.tag = CA_M_OrganizationTag_Pwd;
    _pwdTxtField.delegate = self;
    [_pwdTxtField addTarget:self
                     action:@selector(textFieldChanged:)
           forControlEvents:UIControlEventEditingChanged];
    UIButton* eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    eyeBtn.selected = NO;
    [eyeBtn setImage:kImage(@"icons_eyes_off") forState:UIControlStateNormal];
    [eyeBtn setImage:kImage(@"icons_eyes_on") forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    _pwdTxtField.rightView = eyeBtn;
    _pwdTxtField.rightViewMode = UITextFieldViewModeWhileEditing;
    return _pwdTxtField;
}
-(CA_MUnderlineTextField *)nameTxtField{
    if (_nameTxtField) {
        return _nameTxtField;
    }
    _nameTxtField = [[CA_MUnderlineTextField alloc] init];
    _nameTxtField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:@"请输入机构账号"];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:CA_H_9GRAYCOLOR
                   range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName
                   value:CA_H_FONT_PFSC_Regular(20)
                   range:NSMakeRange(0, attStr.length)];
    _nameTxtField.attributedPlaceholder = attStr;
    _nameTxtField.font = CA_H_FONT_PFSC_Regular(20);
    _nameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_nameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_nameTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _nameTxtField.tag = CA_M_OrganizationTag_Name;
    _nameTxtField.delegate = self;
    [_nameTxtField addTarget:self
                      action:@selector(textFieldChanged:)
            forControlEvents:UIControlEventEditingChanged];
    //记忆上次的登录账户
    NSDictionary* accountStr =  [CA_H_UserDefaults objectForKey:NSLoginAccount];
    _nameTxtField.text = [NSString isValueableString:accountStr[@"username"]]?accountStr[@"username"]:@"";
    return _nameTxtField;
}
-(UILabel *)organizationLb{
    if (_organizationLb) {
        return _organizationLb;
    }
    _organizationLb = [[UILabel alloc] init];
    [_organizationLb configText:@"机构账号登录"
                      textColor:CA_H_4BLACKCOLOR
                           font:28];
    return _organizationLb;
}
@end
