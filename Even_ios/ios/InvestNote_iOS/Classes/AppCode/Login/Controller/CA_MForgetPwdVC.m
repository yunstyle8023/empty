//
//  CA_MForgetPwdVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MForgetPwdVC.h"
#import "CA_MUnderlineTextField.h"
#import "CA_MVerificationLoginVC.h"
#import "CA_MRegisterVC.h"

@interface CA_MForgetPwdVC ()

/// 请输入账号
@property(nonatomic,strong)UILabel* titleLb;
/// 请输入机构账号
@property(nonatomic,strong)CA_MUnderlineTextField* numberTxtField;
/// 下一步
@property(nonatomic,strong)UIButton* nextStpeBtn;
@end

@implementation CA_MForgetPwdVC

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
    
    [self.nextStpeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.numberTxtField.mas_bottom).offset(50*CA_H_RATIO_WIDTH);
        make.width.mas_equalTo(self.numberTxtField);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
}

//#pragma mark - UITextFieldDelegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSUInteger length = textField.text.length + string.length - range.length;
//    if (length >= 1){
//        self.nextStpeBtn.enabled = YES;
//        self.nextStpeBtn.backgroundColor = CA_H_TINTCOLOR;
//        self.numberTxtField.underLineColor = CA_H_TINTCOLOR;
//    }else{
//        self.nextStpeBtn.enabled = NO;
//        self.nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
//        self.numberTxtField.underLineColor = CA_H_BACKCOLOR;
//    }
//    return length >= 1;
//}

- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length >= 1){
        self.nextStpeBtn.enabled = YES;
        self.nextStpeBtn.backgroundColor = CA_H_TINTCOLOR;
        self.numberTxtField.underLineColor = CA_H_TINTCOLOR;
    }else{
        self.nextStpeBtn.enabled = NO;
        self.nextStpeBtn.backgroundColor = CA_H_BACKCOLOR;
        self.numberTxtField.underLineColor = CA_H_BACKCOLOR;
    }
}

/**
 下一步按钮点击事件
 */
- (void)nextStpeBtnAction{
    
    if ([self.titleStr isEqualToString:@"请输入账号"]) {
        [CA_HNetManager postUrlStr:CA_M_Api_QueryUserPhone parameters:@{ @"user_name": self.numberTxtField.text } callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    CA_MVerificationLoginVC* verificationVC = [[CA_MVerificationLoginVC alloc] init];
                    verificationVC.loginStr = @"验证身份";
                    verificationVC.titleStr = @"验证身份";
                    verificationVC.phoneNumStr = netModel.data[@"phone"];
                    verificationVC.bindType = Type_ForgetPwd;
                    verificationVC.organizationName = self.numberTxtField.text;
                    verificationVC.organizationId = netModel.data[@"user_id"];
                    [self.navigationController pushViewController:verificationVC animated:YES];
                    return ;
                }
            }
            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
        } progress:nil];
    }else {
        
        if (self.numberTxtField.text.length > 20 ) {
            [CA_HProgressHUD showHudStr:@"当前机构名称限制长度为20个汉字，请重新输入" rootView:CA_H_MANAGER.loginWindow image:nil];
            return;
        }

        [CA_HNetManager postUrlStr:CA_M_Api_CheckCompanyRegister parameters:@{@"company_name":self.numberTxtField.text} callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    CA_MRegisterVC *registerVC = [[CA_MRegisterVC alloc] init];
                    registerVC.company_name = self.numberTxtField.text;
                    [self.navigationController pushViewController:registerVC animated:YES];
                    return ;
                }
            }

            [CA_HProgressHUD showHudStr:netModel.errmsg rootView:CA_H_MANAGER.loginWindow image:nil];
        } progress:nil];

    }

}

#pragma mark - getter and setter
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
        _numberTxtField.attributedPlaceholder = [self getAttrStr:@"请输入机构账号"];
        _numberTxtField.font = CA_H_FONT_PFSC_Regular(20);
        [_numberTxtField becomeFirstResponder];
//        _numberTxtField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
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
        [_titleLb configText:self.titleStr textColor:CA_H_4BLACKCOLOR font:28];
    }
    return _titleLb;
}
@end
