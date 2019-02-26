//
//  CA_MRegisterVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/8/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MRegisterVC.h"
#import "CA_MUnderlineTextField.h"
#import "CA_MVerificationLoginVC.h"
typedef enum : NSUInteger {
    CA_M_Pwd_Up,
    CA_M_Pwd_Down
} CA_M_Pwd_Tag;

@interface CA_MRegisterVC ()
/// 请输入账号
@property(nonatomic,strong)UILabel* titleLb;
/// 请输入机构账号
@property(nonatomic,strong)CA_MUnderlineTextField* numberTxtField;
/// 下一步
@property(nonatomic,strong)UIButton* nextStpeBtn;
/// 设置新密码
@property(nonatomic,strong)CA_MUnderlineTextField* pwdTxtField;
/// 确认新密码
@property(nonatomic,strong)CA_MUnderlineTextField* confirmTxtField;
@end

@implementation CA_MRegisterVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
    [self setupUI];
    [self setConstraint];
}

- (void)setupUI{
    [self.view addSubview:self.titleLb];
    [self.view addSubview:self.numberTxtField];
    [self.view addSubview:self.pwdTxtField];
    [self.view addSubview:self.confirmTxtField];
    [self.view addSubview:self.nextStpeBtn];
}

- (void)setConstraint{
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30*CA_H_RATIO_WIDTH);
    }];
    
    [self.numberTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(30);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH - 40);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.numberTxtField.mas_bottom).offset(20);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.confirmTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.pwdTxtField.mas_bottom).offset(20);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.nextStpeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.confirmTxtField.mas_bottom).offset(50*CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.confirmTxtField);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
}

- (void)numberTxtFieldChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length >= 1){
        self.numberTxtField.underLineColor = CA_H_TINTCOLOR;
        self.pwdTxtField.underLineColor = CA_H_BACKCOLOR;
        self.confirmTxtField.underLineColor = CA_H_BACKCOLOR;
    }else{
        self.numberTxtField.underLineColor = CA_H_BACKCOLOR;
    }
    
    if ((self.numberTxtField.text.length >= 1) &&
        (self.pwdTxtField.text.length >= 1) &&
        (self.confirmTxtField.text.length >= 1)) {
        self.nextStpeBtn.enabled = YES;
        self.nextStpeBtn.backgroundColor = CA_H_TINTCOLOR;
    }else {
        self.nextStpeBtn.enabled = NO;
        self.nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}


- (void)pwdTxtFieldChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length >= 1){
        self.pwdTxtField.underLineColor = CA_H_TINTCOLOR;
        self.numberTxtField.underLineColor = CA_H_BACKCOLOR;
        self.confirmTxtField.underLineColor = CA_H_BACKCOLOR;
    }else{
        self.pwdTxtField.underLineColor = CA_H_BACKCOLOR;
    }
    
    if ((self.numberTxtField.text.length >= 1) &&
        (self.pwdTxtField.text.length >= 1) &&
        (self.confirmTxtField.text.length >= 1)) {
        self.nextStpeBtn.enabled = YES;
        self.nextStpeBtn.backgroundColor = CA_H_TINTCOLOR;
    }else {
        self.nextStpeBtn.enabled = NO;
        self.nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
    }
    
}


- (void)confirmTxtFieldChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length >= 1){
        self.confirmTxtField.underLineColor = CA_H_TINTCOLOR;
        self.numberTxtField.underLineColor = CA_H_BACKCOLOR;
        self.pwdTxtField.underLineColor = CA_H_BACKCOLOR;
    }else{
        self.confirmTxtField.underLineColor = CA_H_BACKCOLOR;
    }
    
    if ((self.numberTxtField.text.length >= 1) &&
        (self.pwdTxtField.text.length >= 1) &&
        (self.confirmTxtField.text.length >= 1)) {
        self.nextStpeBtn.enabled = YES;
        self.nextStpeBtn.backgroundColor = CA_H_TINTCOLOR;
    }else {
        self.nextStpeBtn.enabled = NO;
        self.nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
    }
}


-(void)nextStpeBtnAction{
    
//    if ([self isEmpty:self.numberTxtField.text]) {
//        [CA_HProgressHUD showHudStr:@"请设置6～16位的字母或数字账号,不支持空格" rootView:CA_H_MANAGER.loginWindow image:nil];
//        return;
//    }
//
//    if ([self deptNameInputShouldChinese:self.numberTxtField.text]) {
//        [CA_HProgressHUD showHudStr:@"请设置6～16位的字母或数字账号" rootView:CA_H_MANAGER.loginWindow image:nil];
//        return;
//    }

    NSDictionary *parameters = @{@"user_name": self.numberTxtField.text,
                                 @"password": self.pwdTxtField.text,
                                 @"tel": self.confirmTxtField.text
                                 };
    
    [CA_HNetManager postUrlStr:CA_M_Api_BindCompanyInfo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                NSMutableDictionary *registerParms = [NSMutableDictionary dictionary];
                [registerParms setValue:self.company_name forKey:@"company_name"];
                [registerParms setValue:self.confirmTxtField.text forKey:@"tel"];
                [registerParms setValue:self.numberTxtField.text forKey:@"user_name"];
                [registerParms setValue:self.pwdTxtField.text forKey:@"password"];
                
                CA_MVerificationLoginVC* verificationVC = [[CA_MVerificationLoginVC alloc] init];
                verificationVC.registerParms = registerParms;
                verificationVC.loginStr = @"注册";
                verificationVC.titleStr = @"验证手机号";
                verificationVC.phoneNumStr = self.confirmTxtField.text;
                verificationVC.bindType = Type_Register;
                [self.navigationController pushViewController:verificationVC animated:YES];

                return ;
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
    } progress:nil];
}

- (BOOL)deptNameInputShouldChinese:(NSString *)str{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isEmpty:(NSString *)str{
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return  YES;
    }else {
        return  NO;
    }
}

#pragma mark - getter and setter

- (void)setTextField:(CA_MUnderlineTextField*)textField  title:(NSString*)title tag:(CA_M_Pwd_Tag)tag sel:(SEL)sel{
    //
    textField.font = CA_H_FONT_PFSC_Regular(20);
    textField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(20) range:NSMakeRange(0, attStr.length)];
    textField.attributedPlaceholder = attStr;
    //
    textField.tag = tag;
    
    if (tag == CA_M_Pwd_Up) {
        textField.secureTextEntry = YES;
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
    
}

- (void)eyeAction:(UIButton*)button{
    button.selected = !button.isSelected;
    self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
    [self.pwdTxtField becomeFirstResponder];
//    if (button.isSelected) {
//        if (button.tag == CA_M_Pwd_Up) {
//            self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
//            [self.pwdTxtField becomeFirstResponder];
//        }else{
//            self.confirmTxtField.secureTextEntry = !self.confirmTxtField.isSecureTextEntry;
//            [self.confirmTxtField becomeFirstResponder];
//        }
//    }else{
//        if (button.tag == CA_M_Pwd_Up) {
//            self.pwdTxtField.secureTextEntry = !self.pwdTxtField.isSecureTextEntry;
//            [self.pwdTxtField becomeFirstResponder];
//        }else{
//            self.confirmTxtField.secureTextEntry = !self.confirmTxtField.isSecureTextEntry;
//            [self.confirmTxtField becomeFirstResponder];
//        }
//    }
}

-(CA_MUnderlineTextField *)confirmTxtField{
    if (_confirmTxtField) {
        return _confirmTxtField;
    }
    _confirmTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_confirmTxtField title:@"请填写手机号码" tag:CA_M_Pwd_Down sel:@selector(eyeAction:)];
    //    _confirmTxtField.delegate = self;
    _confirmTxtField.keyboardType = UIKeyboardTypeNumberPad;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confirmTxtFieldChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_confirmTxtField];
    return _confirmTxtField;
}
-(CA_MUnderlineTextField *)pwdTxtField{
    if (_pwdTxtField) {
        return _pwdTxtField;
    }
    _pwdTxtField = [[CA_MUnderlineTextField alloc] init];
    [self setTextField:_pwdTxtField title:@"请设置登录密码" tag:CA_M_Pwd_Up sel:@selector(eyeAction:)];
    //    _pwdTxtField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pwdTxtFieldChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_pwdTxtField];
    return _pwdTxtField;
}
-(UIButton *)nextStpeBtn{
    if (!_nextStpeBtn) {
        _nextStpeBtn = [[UIButton alloc] init];
        [_nextStpeBtn configTitle:@"下一步" titleColor:kColor(@"#FFFFFF") font:18];
        _nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
        _nextStpeBtn.layer.cornerRadius = 4;
        _nextStpeBtn.layer.masksToBounds = YES;
        [_nextStpeBtn addTarget:self action:@selector(nextStpeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _nextStpeBtn.enabled = NO;
    }
    return _nextStpeBtn;
}
-(CA_MUnderlineTextField *)numberTxtField{
    if (!_numberTxtField) {
        _numberTxtField = [[CA_MUnderlineTextField alloc] init];
        _numberTxtField.underLineColor = CA_H_BACKCOLOR;
        _numberTxtField.attributedPlaceholder = [self getAttrStr:@"请设置登录账号"];
        _numberTxtField.font = CA_H_FONT_PFSC_Regular(20);
        [_numberTxtField becomeFirstResponder];
        //        _numberTxtField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(numberTxtFieldChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_numberTxtField];
    }
    return _numberTxtField;
}
-(NSMutableAttributedString*)getAttrStr:(NSString*)str{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(20) range:NSMakeRange(0, attrString.length)];
    return attrString;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        [_titleLb configText:@"注册账号" textColor:CA_H_4BLACKCOLOR font:28];
    }
    return _titleLb;
}
@end
