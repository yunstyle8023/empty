//
//  CA_M_ VerificationVC.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MVerificationLoginVC.h"
#import "CA_MCountdownBtn.h"
#import "CA_MUnderlineTextField.h"
#import "CA_MVertificationCodeView.h"
#import "CA_MResetPasswordVC.h"
#import "CA_MVerifyCodeView.h"
#import "CA_MNavigationController.h"
#import "CA_MChooseOrganizationVC.h"
#import "CA_MBandingPhoneVC.h"
#import "CA_HHomePageViewController.h"
#import "CA_MRegisterSuccessVC.h"
#import "CXAHyperlinkLabel.h"
#import "CA_MDiscoverProjectH5VC.h"
#import <Bugly/Bugly.h>

@interface CA_MVerificationLoginVC ()
<VertificationCodeViewDelegate,
CA_MCountdownBtnDelegate>

@property (nonatomic, strong) CA_MNavigationController *h5Navi;

/// 显示的标题
@property(nonatomic,strong)UILabel* verificationLb;
/// 手机号
@property(nonatomic,strong)UILabel* phoneNumberLb;
/// 获取验证码按钮
@property(nonatomic,strong)CA_MCountdownBtn* countdownBtn;
/// 带下划线的view 1-4分别对应四位验证码
@property(nonatomic,strong)CA_MVertificationCodeView* verificationCodeView;

@property (nonatomic,strong) CXAHyperlinkLabel *messageLb;

/// 登录按钮
@property(nonatomic,strong)UIButton* loginBtn;
/// 记录错误次数
@property(nonatomic,assign)int totalCount;
@end

@implementation CA_MVerificationLoginVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
    [self setupUI];
    [self setConstraint];
    self.totalCount = 0;
    [self getVerifyCode];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

/**
 登录按钮点击事件
 */
- (void)loginAction{
    
    if (self.bindType == Type_Register) {
        
        [self.registerParms setValue:self.verificationCodeView.vertificationCode forKey:@"verify_code"];

        [CA_HNetManager postUrlStr:CA_M_Api_Register parameters:self.registerParms callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {//注册成功 直接登录

                    [self saveAccountInfo:netModel];
                    
                }else if(netModel.errcode.intValue == 12005){//信息已提交
                    CA_MRegisterSuccessVC *registerSuccessVC = [CA_MRegisterSuccessVC new];
                    CA_H_WeakSelf(self)
                    registerSuccessVC.pushBlock = ^{
                        CA_H_StrongSelf(self)
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    };
                    CA_MNavigationController* navi = [[CA_MNavigationController alloc] initWithRootViewController:registerSuccessVC];
                    [self presentViewController:navi animated:YES completion:nil];
                }
                return ;
            }
            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
        } progress:nil];
        
    }else { 
        NSDictionary * parameters = @{@"phone": [self.phoneNumStr stringByReplacingOccurrencesOfString:@" " withString:@""] , //# 必填
                                      @"verify_code": self.verificationCodeView.vertificationCode , //# 必填 验证码
                                      };
        if (self.bindType == Type_BindPhone) {
            [CA_HNetManager postUrlStr:CA_M_Api_ValidPhoneBindCode parameters:parameters callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.intValue == 0) {
                        //
                        [CA_H_MANAGER setUserPhone:[self.phoneNumStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
                        //保存是否绑定了手机号
                        [CA_H_MANAGER saveBingdPhoneNumber:YES];
                        //退出登录页面
                        [CA_H_MANAGER hideLoginWindow:YES];
                    }else{
                        [self.verificationCodeView cleanVertificationCode];
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    }
                }
            } progress:nil];
        }else if (self.bindType == Type_ForgetPwd) {
            [CA_HNetManager postUrlStr:CA_M_Api_ValidForgetPwdCode parameters:parameters callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.intValue == 0) {
                        CA_MResetPasswordVC *setpwdVC = [CA_MResetPasswordVC new];
                        setpwdVC.organizationName = self.organizationName;
                        setpwdVC.organizationId = self.organizationId;
                        CA_MNavigationController* navi = [[CA_MNavigationController alloc] initWithRootViewController:setpwdVC];
                        [self presentViewController:navi animated:YES completion:nil];
                    }else{
                        [self.verificationCodeView cleanVertificationCode];
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    }
                }
            } progress:nil];
        }else if (self.bindType == Type_PhoneLogin){
            [CA_HNetManager postUrlStr:CA_M_Api_ValidPhoneLoginCode parameters:parameters callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.intValue == 0) {
                        [self saveAccountInfo:netModel];
                    }else{
                        [self.verificationCodeView cleanVertificationCode];
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    }
                }
            } progress:nil];
        }
    }
    
}

/**
 保存登录成功后的账号信息
 */
- (void)saveAccountInfo:(CA_HNetModel*)netModel{
    
    [CA_HProgressHUD showHudStr:@"登录成功!" rootView:CA_H_MANAGER.mainWindow image:nil];
    
    [CA_H_UserDefaults setObject:nil forKey:NSLoginAccount];
    [CA_H_MANAGER saveToken:netModel.data[@"token"]];
    
    NSNumber *notifyCount = netModel.data[@"notify_count"];
    CA_H_MANAGER.tabbarPoint.hidden = !(notifyCount.integerValue>0);
    
    [CA_HHomePageViewController reloadData];
    
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
}

#pragma mark - CA_MCountdownBtnDelegate

- (void)getVerifyCode{
    
    
    if (self.totalCount >= 3) {
        [self.view resignFirstResponder];
        //
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请确认号码是否正确，如收不到短信请联系客服：400-770-8988" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.totalCount = 0;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-770-8988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return ;
    }
    
    CA_MVerifyCodeView* verifyCodeView = [[CA_MVerifyCodeView alloc] init];
    [verifyCodeView showInView:CA_H_MANAGER.loginWindow];
    
    __weak CA_MVerifyCodeView* weakVerifyCodeView = verifyCodeView;
    CA_H_WeakSelf(self)
    verifyCodeView.isCorrect = ^(BOOL isCorrect) {
        
        if (!isCorrect) {
            [CA_HProgressHUD showHudStr:@"验证码输入错误" rootView:CA_H_MANAGER.loginWindow image:nil];
            return ;
        }
        
        CA_H_StrongSelf(self)
        if (isCorrect) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.countdownBtn startCountDown];
                [self.verificationCodeView becomeFirstResponder];
                
                NSDictionary *parameters = @{@"phone":[self.phoneNumStr stringByReplacingOccurrencesOfString:@" " withString:@""]};
                
                if (self.bindType == Type_BindPhone) {
                    [CA_HNetManager postUrlStr:CA_M_Api_GenPhoneBind parameters:parameters callBack:^(CA_HNetModel *netModel) {
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.intValue == 0) {
                                self.totalCount++;
                            }
                            return ;
                        }
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    } progress:nil];
                }else if (self.bindType == Type_PhoneLogin) {
                    [CA_HNetManager postUrlStr:CA_M_Api_GenPhoneLogin parameters:parameters callBack:^(CA_HNetModel *netModel) {
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.intValue == 0) {
                                self.totalCount++;
                            }
                            return ;
                        }
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    } progress:nil];
                }else if (self.bindType == Type_ForgetPwd) {
                    [CA_HNetManager postUrlStr:CA_M_Api_GenForgetPwd parameters:parameters callBack:^(CA_HNetModel *netModel) {
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.intValue == 0) {
                                self.totalCount++;
                            }
                            return ;
                        }
                       [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    } progress:nil];
                }else if (self.bindType == Type_Register) {
                    [CA_HNetManager postUrlStr:CA_M_Api_GenPhoneRegister parameters:@{@"tel":[self.phoneNumStr stringByReplacingOccurrencesOfString:@" " withString:@""]} callBack:^(CA_HNetModel *netModel) {
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.intValue == 0) {
                                self.totalCount++;
                            }
                            return ;
                        }
                        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
                    } progress:nil];
                }
            });
        }
    };
}

#pragma mark - VertificationCodeViewDelegate

- (void)didFinishVertificationCode:(NSString *)vertificationCode{
    self.loginBtn.backgroundColor = CA_H_TINTCOLOR;
    self.loginBtn.enabled = YES;
}

- (void)deleteVertificationCode:(NSString *)vertificationCode{
    self.loginBtn.backgroundColor = CA_H_BACKCOLOR;
    self.loginBtn.enabled = NO;
}

#pragma mark - Private

/**
 添加控件
 */
- (void)setupUI{
    [self.view addSubview:self.verificationLb];
    [self.view addSubview:self.phoneNumberLb];
    [self.view addSubview:self.countdownBtn];
    [self.view addSubview:self.verificationCodeView];
    [self.view addSubview:self.loginBtn];
    if (self.bindType == Type_Register) {
        [self.view addSubview:self.messageLb];
    }
}

/**
 添加控件约束
 */
- (void)setConstraint{
    [self.verificationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30 * CA_H_RATIO_WIDTH);
    }];
    
    [self.phoneNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.verificationLb);
        make.top.mas_equalTo(self.verificationLb.mas_bottom).offset(30);
    }];

    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.centerY.mas_equalTo(self.phoneNumberLb);
    }];

    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.phoneNumberLb.mas_bottom).offset(70);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(45);
    }];

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationCodeView.mas_bottom)
        .offset(self.bindType==Type_Register?56*2 * CA_H_RATIO_WIDTH:50 * CA_H_RATIO_WIDTH);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.verificationCodeView);
        make.height.mas_equalTo(48 * CA_H_RATIO_WIDTH);
    }];
    
    if (self.bindType == Type_Register) {
        [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.view).offset(20);
            make.top.mas_equalTo(self.verificationCodeView.mas_bottom).offset(20);
        }];
    }
}

#pragma mark - Getter and Setter
-(NSMutableDictionary *)registerParms{
    if (!_registerParms) {
        _registerParms = @{}.mutableCopy;
    }
    return _registerParms;
}

-(CXAHyperlinkLabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [CXAHyperlinkLabel new];
        _messageLb.numberOfLines = 0;
        _messageLb.textAlignment = NSTextAlignmentCenter;
        [_messageLb configText:@"注册即表示您已阅读并同意《用户注册协议》"
                     textColor:CA_H_9GRAYCOLOR
                          font:14];
        [_messageLb changeLineSpaceWithSpace:6];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
                                             initWithAttributedString:_messageLb.attributedText];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, _messageLb.attributedText.length-8)];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(_messageLb.attributedText.length-8, 8)];
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(0, _messageLb.attributedText.length)];
        _messageLb.attributedText = attStr;
        [_messageLb setURL:[NSURL URLWithString:@""] forRange:NSMakeRange(_messageLb.attributedText.length-8, 8)];
        _messageLb.linkAttributesWhenTouching = nil;
        CA_H_WeakSelf(self)
        _messageLb.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange textRange, NSArray *textRects) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
            h5VC.urlStr = [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, @"/company/client/v1/getregisterstatement"];
            self.h5Navi = [[CA_MNavigationController alloc] initWithRootViewController:h5VC];
            h5VC.navigationItem.leftBarButtonItems = [self leftBarButtonItems];
            [self presentViewController:self.h5Navi animated:YES completion:nil];
        };
    }
    return _messageLb;
}

- (NSArray *)leftBarButtonItems {
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame = CGRectMake(15, 5, 38, 38);
    
    [backButton setImage:[UIImage imageNamed:@"icons_back"] forState:UIControlStateNormal];
    
    backButton.imageView.sd_resetLayout
    .widthIs(18)
    .heightEqualToWidth()
    .centerYEqualToView(backButton)
    .leftSpaceToView(backButton, 5*CA_H_RATIO_WIDTH);
    
    [backButton addTarget: self action: @selector(onH5Back:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    return @[spaceItem, backItem];
}

- (void)onH5Back:(UIButton *)sender {
    [self.h5Navi dismissViewControllerAnimated:YES completion:nil];
    self.h5Navi = nil;
}

-(UILabel *)verificationLb{
    if (_verificationLb) {
        return _verificationLb;
    }
    _verificationLb = [[UILabel alloc] init];
    [_verificationLb configText:self.titleStr textColor:CA_H_4BLACKCOLOR font:28];
    return _verificationLb;
}
-(UILabel *)phoneNumberLb{
    if (_phoneNumberLb) {
        return _phoneNumberLb;
    }
    _phoneNumberLb = [[UILabel alloc] init];
    
    if (self.bindType == Type_ForgetPwd) {
        NSMutableString *tempStr = [NSMutableString new];
        [tempStr appendFormat:@"%@", [self.phoneNumStr substringWithRange:NSMakeRange(0, 3)]];
        [tempStr appendString:@"****"];
        [tempStr appendFormat:@"%@", [self.phoneNumStr substringWithRange:NSMakeRange(7, 4)]];
        [_phoneNumberLb configText:[NSString stringWithFormat:@"+86 %@",tempStr.copy] textColor:CA_H_4BLACKCOLOR font:20];
    }else {
        [_phoneNumberLb configText:[NSString stringWithFormat:@"+86 %@",self.phoneNumStr] textColor:CA_H_4BLACKCOLOR font:20];
    }
    
    return _phoneNumberLb;
}
-(CA_MCountdownBtn *)countdownBtn{
    if (_countdownBtn) {
        return _countdownBtn;
    }
    _countdownBtn = [[CA_MCountdownBtn alloc] init];
    _countdownBtn.isVerificationCode = NO;
    _countdownBtn.delegate = self;
    [_countdownBtn configTitle:@"获取验证码" titleColor:CA_H_TINTCOLOR font:18];
    return _countdownBtn;
}
-(CA_MVertificationCodeView *)verificationCodeView{
    if (_verificationCodeView) {
        return _verificationCodeView;
    }
    _verificationCodeView = [[CA_MVertificationCodeView alloc] init];
    _verificationCodeView.delegate = self;
    _verificationCodeView.secureTextEntry =NO;
//    [_verificationCodeView becomeFirstResponder];
    return _verificationCodeView;
}
-(UIButton *)loginBtn{
    if (_loginBtn) {
        return _loginBtn;
    }
    _loginBtn = [[UIButton alloc] init];
    [_loginBtn configTitle:self.loginStr titleColor:kColor(@"#FFFFFF") font:18];
    [_loginBtn setBackgroundColor:CA_H_BACKCOLOR];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.enabled = NO;
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    return _loginBtn;
}
@end
