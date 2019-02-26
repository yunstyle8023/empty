//
//  ViewController.m
//  ceshi
//  Created by yezhuge on 2017/11/15.
//  God bless me without no bugs.
//

#import "CA_MPhoneLoginVC.h"
#import "CA_MVerificationLoginVC.h"
#import "CA_MOrganizationLoginVC.h"
#import "CA_MBandingPhoneVC.h"
#import "CA_HNetManager.h"
#import "CA_MTryVC.h"
#import "CA_MTryH5VC.h"
#import "CA_MForgetPwdVC.h"
#import "CA_MNavigationController.h"

@interface CA_MPhoneLoginVC ()
<UITextFieldDelegate,
UIActionSheetDelegate>

{
    NSString* previousTextFieldContent;
    UITextRange* previousSelection;
}
/// 手机号登录
@property(nonatomic,strong)UILabel* loginLb;
/// +86
@property(nonatomic,strong)UILabel* countryLb;
/// 输入手机号
@property(nonatomic,strong)UITextField* phoneNumberTxtField;
/// 横线
@property(nonatomic,strong)UIView* horizalLine;
/// 账号登录
@property(nonatomic,strong)UIButton* organizationBtn;
/// 小箭头
@property(nonatomic,strong)UIImageView* arrowImgView;
/// 申请试用
@property(nonatomic,strong)UIButton* tryBtn;
/// 下一步
@property(nonatomic,strong)UIButton* nextStepBtn;

@end

@implementation CA_MPhoneLoginVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
    [self setupUI];
    [self setConstraint];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = textField.text.length + string.length - range.length;
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    if (length >= 13){
        self.nextStepBtn.enabled = YES;
        self.nextStepBtn.backgroundColor = CA_H_TINTCOLOR;
        self.horizalLine.backgroundColor = CA_H_BACKCOLOR;
    }else{
        self.nextStepBtn.enabled = NO;
        self.nextStepBtn.backgroundColor = CA_H_BACKCOLOR;
        self.horizalLine.backgroundColor = CA_H_TINTCOLOR;
    }
    return length <= 13;
}

/**
 实现手机号码格式化 344(xxx xxxx xxxx)
 
 @param textField <#textField description#>
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

#pragma mark - Private

/**
 添加控件
 */
- (void)setupUI{
    [self.view addSubview:self.loginLb];
    [self.view addSubview:self.countryLb];
    [self.view addSubview:self.phoneNumberTxtField];
    [self.view addSubview:self.horizalLine];
    [self.view addSubview:self.organizationBtn];
    [self.view addSubview:self.arrowImgView];
    [self.view addSubview:self.tryBtn];
    [self.view addSubview:self.nextStepBtn];
}

/**
 添加控件的约束
 */
- (void)setConstraint{
    [self.loginLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30 * CA_H_RATIO_WIDTH);
    }];
    
    [self.countryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.loginLb);
        make.top.mas_equalTo(self.loginLb.mas_bottom).offset(30);
    }];
    
    [self.phoneNumberTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryLb.mas_trailing).offset(20);
        make.width.mas_equalTo(278*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self.countryLb);
    }];
    
    [self.horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.countryLb.mas_bottom).offset(10);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH - 20*2);
        make.height.mas_equalTo(1.25);
    }];
    
    [self.organizationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.horizalLine);
        make.top.mas_equalTo(self.horizalLine.mas_bottom).offset(20);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.organizationBtn);
        make.leading.mas_equalTo(self.organizationBtn.mas_trailing).offset(0);
    }];
    
    [self.tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.organizationBtn);
        make.trailing.mas_equalTo(self.horizalLine);
    }];
    
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tryBtn.mas_bottom).offset(50 * CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.horizalLine);
        make.height.mas_equalTo(48 * CA_H_RATIO_WIDTH);
    }];
}

/**
 账号登录
 */
- (void)organizationLoginAction{
//    CA_MOrganizationLoginVC* organizationVC = [[CA_MOrganizationLoginVC alloc] init];
//    [self.navigationController pushViewController:organizationVC animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 申请试用
 */
- (void)tryAction{
    
    CA_MForgetPwdVC* forgetVC = [[CA_MForgetPwdVC alloc] init];
    forgetVC.titleStr = @"创建机构";
    [self.navigationController pushViewController:forgetVC animated:YES];
    
//    CA_MTryH5VC* tryH5VC = [[CA_MTryH5VC alloc] init];
//    CA_MNavigationController* navi = (CA_MNavigationController*)CA_H_MANAGER.loginWindow.rootViewController;
//    [navi pushViewController:tryH5VC animated:YES];
}

/**
 下一步按钮点击事件
 */
- (void)nextBtnAction{
    NSString* phoneNumber = [self.phoneNumberTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self isMobileNumber:phoneNumber]) {
        [CA_HProgressHUD showHudStr:@"请输入正确的手机号" rootView:CA_H_MANAGER.loginWindow image:nil];
        return;
    }
    [CA_HNetManager postUrlStr:CA_M_Api_CheckPhoneExist parameters:@{ @"phone": phoneNumber } callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                CA_MVerificationLoginVC* verificationVC = [[CA_MVerificationLoginVC alloc] init];
                verificationVC.loginStr = @"登录";
                verificationVC.titleStr = @"输入验证码";
                verificationVC.phoneNumStr = self.phoneNumberTxtField.text;
                verificationVC.bindType = Type_PhoneLogin;
                [self.navigationController pushViewController:verificationVC animated:YES];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
//        }
    } progress:nil];
    
}

/**
 正则判断手机号码地址格式

 @param mobileNum <#mobileNum description#>
 @return <#return value description#>
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/166/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170µ
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
//    NSString *MOBILE = @"^1\\d{10}$/";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [regextestmobile evaluateWithObject:mobileNum];
    
    if ([[mobileNum substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]
        &&
        [self isPureInt:mobileNum]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - Getter and Setter
- (UIButton *)nextStepBtn{
    if (_nextStepBtn) {
        return _nextStepBtn;
    }
    _nextStepBtn = [[UIButton alloc] init];
    [_nextStepBtn configTitle:@"下一步" titleColor:kColor(@"#FFFFFF") font:18];
    _nextStepBtn.backgroundColor = CA_H_BACKCOLOR;
    _nextStepBtn.layer.cornerRadius = 4;
    _nextStepBtn.layer.masksToBounds = YES;
    _nextStepBtn.enabled = NO;
    [_nextStepBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _nextStepBtn;
}
- (UIButton *)tryBtn{
    if (_tryBtn) {
        return _tryBtn;
    }
    _tryBtn = [[UIButton alloc] init];
    
//    隐藏申请试用功能 by hyz
//    [_tryBtn configTitle:@"申请试用" titleColor:CA_H_TINTCOLOR font:14];
    [_tryBtn configTitle:@"注册" titleColor:CA_H_TINTCOLOR font:14];
    [_tryBtn addTarget:self action:@selector(tryAction) forControlEvents:UIControlEventTouchUpInside];
    
    return _tryBtn;
}
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"icons_Details");
    return _arrowImgView;
}
- (UIButton *)organizationBtn{
    if (_organizationBtn) {
        return _organizationBtn;
    }
    _organizationBtn = [[UIButton alloc] init];
    [_organizationBtn configTitle:@"账号登录" titleColor:CA_H_TINTCOLOR font:14];
    [_organizationBtn addTarget:self action:@selector(organizationLoginAction) forControlEvents:UIControlEventTouchUpInside];
    return _organizationBtn;
}
- (UIView *)horizalLine{
    if (_horizalLine) {
        return _horizalLine;
    }
    _horizalLine = [[UIView alloc] init];
    _horizalLine.backgroundColor = CA_H_TINTCOLOR;
    return _horizalLine;
}
- (UITextField *)phoneNumberTxtField{
    if (_phoneNumberTxtField) {
        return _phoneNumberTxtField;
    }
    _phoneNumberTxtField = [[UITextField alloc] init];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(20) range:NSMakeRange(0, attrString.length)];
    _phoneNumberTxtField.attributedPlaceholder = attrString;
    _phoneNumberTxtField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTxtField.delegate = self;
    _phoneNumberTxtField.font = CA_H_FONT_PFSC_Regular(20);
    [_phoneNumberTxtField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumberTxtField becomeFirstResponder];
    return _phoneNumberTxtField;
}
- (UILabel *)countryLb{
    if (_countryLb) {
        return _countryLb;
    }
    _countryLb = [[UILabel alloc] init];
    [_countryLb configText:@"+86" textColor:CA_H_4BLACKCOLOR font:20];
    return _countryLb;
}
- (UILabel *)loginLb{
    if (_loginLb) {
        return _loginLb;
    }
    _loginLb = [[UILabel alloc] init];
    [_loginLb configText:@"手机号登录" textColor:CA_H_4BLACKCOLOR font:28];
    return _loginLb;
}

@end
