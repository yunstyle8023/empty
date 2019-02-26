//
//  CA_M_BandingVC.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MBandingPhoneVC.h"
#import "CA_MVerificationLoginVC.h"

@interface CA_MBandingPhoneVC ()
<UITextFieldDelegate>
{
    NSString* previousTextFieldContent;
    UITextRange* previousSelection;
}
/// 绑定手机号
@property(nonatomic,strong)UILabel* bandingPhoneLb;
/// 提示
@property(nonatomic,strong)UILabel* messageLb;
/// 国家区号
@property(nonatomic,strong)UILabel* countryLb;
/// 输入手机号TxtField
@property(nonatomic,strong)UITextField* phoneTxtField;
/// 下划线
@property(nonatomic,strong)UIView* lineView;
/// 下一步
@property(nonatomic,strong)UIButton* nextStepBtn;
@end

@implementation CA_MBandingPhoneVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = textField.text.length + string.length - range.length;
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    if (length >= 13){
        self.nextStepBtn.enabled = YES;
        self.nextStepBtn.backgroundColor = CA_H_TINTCOLOR;
        self.lineView.backgroundColor = CA_H_BACKCOLOR;
    }else{
        self.nextStepBtn.enabled = NO;
        self.nextStepBtn.backgroundColor = CA_H_BACKCOLOR;
        self.lineView.backgroundColor = CA_H_TINTCOLOR;
    }
    return length <= 13;
}

/**
 实现手机号码格式化 344(xxx xxxx xxxx)

 @param textField <#textField description#>
 */
- (void)textFieldEditingChanged:(UITextField *)textField
{
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
    [self.view addSubview:self.bandingPhoneLb];
    [self.view addSubview:self.messageLb];
    [self.view addSubview:self.countryLb];
    [self.view addSubview:self.phoneTxtField];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.nextStepBtn];
}

/**
 添加控件约束
 */
- (void)setupConstraint{
    [self.bandingPhoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30 * CA_H_RATIO_WIDTH);
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bandingPhoneLb);
        make.top.mas_equalTo(self.bandingPhoneLb.mas_bottom).offset(10);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH - 40);
    }];
    
    [self.countryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.messageLb);
        make.top.mas_equalTo(self.messageLb.mas_bottom).offset(30);
    }];
    
    [self.phoneTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.countryLb);
        make.leading.mas_equalTo(self.countryLb.mas_trailing).offset(20);
        make.width.mas_equalTo(278 * CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.countryLb.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(50 * CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.lineView);
        make.height.mas_equalTo(48 * CA_H_RATIO_WIDTH);
    }];
}

/**
 正则判断手机号码地址格式
 
 @param mobileNum <#mobileNum description#>
 @return <#return value description#>
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
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

/**
 下一步点击事件
 */
- (void)nextStepBtnAction{
    NSString* phoneNumber = [self.phoneTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self isMobileNumber:phoneNumber]) {
        [CA_HProgressHUD showHudStr:@"请输入正确的手机号" rootView:CA_H_MANAGER.loginWindow image:nil];
        return;
    }

    [CA_HNetManager postUrlStr:CA_M_Api_CheckPhoneBind parameters:@{ @"phone": phoneNumber } callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                CA_MVerificationLoginVC* verificationVC = [[CA_MVerificationLoginVC alloc] init];
                verificationVC.loginStr = @"验证身份";
                verificationVC.titleStr = @"输入验证码";
                verificationVC.phoneNumStr = self.phoneTxtField.text;
                verificationVC.bindType = Type_BindPhone;
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

#pragma mark - Getter and Setter
-(UIButton *)nextStepBtn{
    if (_nextStepBtn) {
        return _nextStepBtn;
    }
    _nextStepBtn = [[UIButton alloc] init];
    [_nextStepBtn configTitle:@"下一步" titleColor:kColor(@"#FFFFFF") font:18];
    _nextStepBtn.backgroundColor = CA_H_BACKCOLOR;
    _nextStepBtn.layer.cornerRadius = 4;
    _nextStepBtn.layer.masksToBounds = YES;
    _nextStepBtn.enabled = NO;
    [_nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _nextStepBtn;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_TINTCOLOR;
    return _lineView;
}
-(UITextField *)phoneTxtField{
    if (_phoneTxtField) {
        return _phoneTxtField;
    }
    _phoneTxtField = [[UITextField alloc] init];
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:@"输入手机号"];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(20) range:NSMakeRange(0, attStr.length)];
    _phoneTxtField.attributedPlaceholder = attStr;
    _phoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTxtField.delegate = self;
    _phoneTxtField.font = CA_H_FONT_PFSC_Regular(20);
    [_phoneTxtField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTxtField becomeFirstResponder];
    return _phoneTxtField;
}
-(UILabel *)messageLb{
    if (_messageLb) {
        return _messageLb;
    }
    _messageLb = [[UILabel alloc] init];
    [_messageLb configText:@"请输入手机号绑定，完成身份信息验证" textColor:CA_H_4BLACKCOLOR font:14];
    _messageLb.numberOfLines = 0 ;
    return _messageLb;
}
-(UILabel *)countryLb{
    if (_countryLb) {
        return _countryLb;
    }
    _countryLb = [[UILabel alloc] init];
    [_countryLb configText:@"+86" textColor:CA_H_4BLACKCOLOR font:20];
    return _countryLb;
}
-(UILabel *)bandingPhoneLb{
    if (_bandingPhoneLb) {
        return _bandingPhoneLb;
    }
    _bandingPhoneLb = [[UILabel alloc] init];
    [_bandingPhoneLb configText:[NSString stringWithFormat:@"Hi，%@",self.userName] textColor:CA_H_4BLACKCOLOR font:28];
    return _bandingPhoneLb;
}

@end
