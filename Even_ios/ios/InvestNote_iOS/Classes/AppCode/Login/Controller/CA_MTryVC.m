//
//  CA_MTryVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MTryVC.h"
#import "CA_MUnderlineTextField.h"

@interface CA_MTryVC ()
/// 申请试用
@property(nonatomic,strong)UILabel* tryLb;
/// 信息
@property(nonatomic,strong)UILabel* messageLb;
/// 姓名
@property(nonatomic,strong)UILabel* nameLb;
///
@property(nonatomic,strong)CA_MUnderlineTextField* nameTxtField;
/// 机构
@property(nonatomic,strong)UILabel* organizationLb;
///
@property(nonatomic,strong)CA_MUnderlineTextField* organizationTxtField;
/// 职位
@property(nonatomic,strong)UILabel* positionLb;
///
@property(nonatomic,strong)CA_MUnderlineTextField* positionTxtField;
/// 手机号
@property(nonatomic,strong)UILabel* numberLb;
///
@property(nonatomic,strong)CA_MUnderlineTextField* numberTxtField;
/// 提交按钮
@property(nonatomic,strong)UIButton* submitBtn;
@end

@implementation CA_MTryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:kImage(@"logo_34")];
    [self setupUI];
    [self setConstraint];
}

- (void)setupUI{
    [self.view addSubview:self.tryLb];
    [self.view addSubview:self.messageLb];
    [self.view addSubview:self.nameLb];
    [self.view addSubview:self.nameTxtField];
    [self.view addSubview:self.organizationLb];
    [self.view addSubview:self.organizationTxtField];
    [self.view addSubview:self.positionLb];
    [self.view addSubview:self.positionTxtField];
    [self.view addSubview:self.numberLb];
    [self.view addSubview:self.numberTxtField];
    [self.view addSubview:self.submitBtn];
}

- (void)setConstraint{
    [self.tryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(30*CA_H_RATIO_WIDTH);
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tryLb.mas_bottom).offset(20);
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
    }];

    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.messageLb.mas_bottom).offset(30);
    }];
    
    [self.nameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLb);
        make.top.mas_equalTo(self.nameLb.mas_bottom).offset(5);
        make.width.mas_equalTo(self.messageLb);
        make.height.mas_equalTo(35*CA_H_RATIO_WIDTH);
    }];
    
    [self.organizationLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameTxtField);
        make.top.mas_equalTo(self.nameTxtField.mas_bottom).offset(10);
    }];
    
    [self.organizationTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.organizationLb);
        make.top.mas_equalTo(self.organizationLb.mas_bottom).offset(5);
        make.width.mas_equalTo(self.messageLb);
        make.height.mas_equalTo(35*CA_H_RATIO_WIDTH);
    }];
    
    [self.positionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.organizationTxtField);
        make.top.mas_equalTo(self.organizationTxtField.mas_bottom).offset(10);
    }];
    
    [self.positionTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.positionLb);
        make.top.mas_equalTo(self.positionLb.mas_bottom).offset(5);
        make.width.mas_equalTo(self.messageLb);
        make.height.mas_equalTo(35*CA_H_RATIO_WIDTH);
    }];
    
    [self.numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.positionTxtField);
        make.top.mas_equalTo(self.positionTxtField.mas_bottom).offset(10);
    }];
    
    [self.numberTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.numberLb);
        make.top.mas_equalTo(self.numberLb.mas_bottom).offset(5);
        make.width.mas_equalTo(self.messageLb);
        make.height.mas_equalTo(35*CA_H_RATIO_WIDTH);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.numberTxtField.mas_bottom).offset(30);
        make.width.mas_equalTo(self.nameTxtField);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
}

- (void)submitAction{
    
}

#pragma mark - getter and setter
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn configTitle:@"提交" titleColor:kColor(@"#FFFFFF") font:18];
        _submitBtn.backgroundColor = CA_H_BACKCOLOR;
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(CA_MUnderlineTextField *)numberTxtField{
    if (!_numberTxtField) {
        _numberTxtField = [[CA_MUnderlineTextField alloc] init];
        _numberTxtField.underLineColor = CA_H_BACKCOLOR;
        _numberTxtField.attributedPlaceholder = [self getAttrStr:@"请输入您的手机号"];
        _numberTxtField.font = CA_H_FONT_PFSC_Regular(18);
    }
    return _numberTxtField;
}
-(UILabel *)numberLb{
    if (!_numberLb) {
        _numberLb = [[UILabel alloc] init];
        [_numberLb configText:@"手机号" textColor:CA_H_4BLACKCOLOR font:16];
    }
    return _numberLb;
}
-(CA_MUnderlineTextField *)positionTxtField{
    if (!_positionTxtField) {
        _positionTxtField = [[CA_MUnderlineTextField alloc] init];
        _positionTxtField.underLineColor = CA_H_BACKCOLOR;
        _positionTxtField.attributedPlaceholder = [self getAttrStr:@"请输入您的职位"];
        _positionTxtField.font = CA_H_FONT_PFSC_Regular(18);
    }
    return _positionTxtField;
}
-(UILabel *)positionLb{
    if (!_positionLb) {
        _positionLb = [[UILabel alloc] init];
        [_positionLb configText:@"职位" textColor:CA_H_4BLACKCOLOR font:16];
    }
    return _positionLb;
}
-(CA_MUnderlineTextField *)organizationTxtField{
    if (!_organizationTxtField) {
        _organizationTxtField = [[CA_MUnderlineTextField alloc] init];
        _organizationTxtField.underLineColor = CA_H_BACKCOLOR;
        _organizationTxtField.attributedPlaceholder = [self getAttrStr:@"请输入您的机构名称"];
        _organizationTxtField.font = CA_H_FONT_PFSC_Regular(18);
    }
    return _organizationTxtField;
}
-(UILabel *)organizationLb{
    if (!_organizationLb) {
        _organizationLb = [[UILabel alloc] init];
        [_organizationLb configText:@"机构" textColor:CA_H_4BLACKCOLOR font:16];
    }
    return _organizationLb;
}
-(CA_MUnderlineTextField *)nameTxtField{
    if (!_nameTxtField) {
        _nameTxtField = [[CA_MUnderlineTextField alloc] init];
        _nameTxtField.underLineColor = CA_H_BACKCOLOR;
        _nameTxtField.attributedPlaceholder = [self getAttrStr:@"请输入您的真实姓名"];
        _nameTxtField.font = CA_H_FONT_PFSC_Regular(18);
    }
    return _nameTxtField;
}
-(NSMutableAttributedString*)getAttrStr:(NSString*)str{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:NSMakeRange(0, attrString.length)];
    return attrString;
}
-(UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        [_nameLb configText:@"姓名" textColor:CA_H_4BLACKCOLOR font:16];
    }
    return _nameLb;
}
-(UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [[UILabel alloc] init];
        _messageLb.numberOfLines = 0;
        [_messageLb configText:@"申请提交后，三个工作日内将有工作人员主动与您取得联系。" textColor:CA_H_4BLACKCOLOR font:14];
    }
    return _messageLb;
}
-(UILabel *)tryLb{
    if (!_tryLb) {
        _tryLb = [[UILabel alloc] init];
        [_tryLb configText:@"申请试用" textColor:CA_H_4BLACKCOLOR font:28];
    }
    return _tryLb;
}
@end
