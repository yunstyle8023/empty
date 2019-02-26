
//
//  CA_MFeedbackVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFeedbackVC.h"
#import "FSTextView.h"
#import "CA_MUnderlineTextField.h"

@interface CA_MFeedbackVC ()
<UITextViewDelegate,
UITextFieldDelegate>
@property (nonatomic,strong) FSTextView *textView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) CA_MUnderlineTextField *underlineTxtField;
@property (nonatomic,strong) UIButton *submitBtn;
@end

@implementation CA_MFeedbackVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助与反馈";
    [self setupUI];
    [self setConstraint];
}

-(void)setupUI{
    [self.view addSubview:self.textView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.underlineTxtField];
    [self.view addSubview:self.submitBtn];
}

- (void)setConstraint{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(17);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(192*CA_H_RATIO_WIDTH);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.underlineTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(52*CA_H_RATIO_WIDTH);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.underlineTxtField.mas_bottom).offset(60);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
}

-(void)submitAction{
    [self resignFirstResponder];
    NSDictionary* parameters = @{@"content" : self.textView.text ,// # 必填
                                 @"phone": self.underlineTxtField.text};// # 选填
    [CA_HNetManager postUrlStr:CA_M_Api_CreateFeedback parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [CA_HProgressHUD showHudStr:@"反馈已成功提交，我们一定加快改正"];
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - getter and setter
-(FSTextView *)textView{
    if (_textView) {
        return _textView;
    }
    _textView= [[FSTextView alloc] init];
    _textView.placeholderColor = CA_H_9GRAYCOLOR;
    _textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
    _textView.placeholder = @"请简要描述您的问题或建议";
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    CA_H_WeakSelf(self);
    // 添加输入改变Block回调
    [_textView addTextDidChangeHandler:^(FSTextView *textView) {
        CA_H_StrongSelf(self);
        if ([NSString isValueableString:textView.text]) {
            self.submitBtn.enabled = YES;
            self.submitBtn.backgroundColor = CA_H_TINTCOLOR;
        }else{
            self.submitBtn.enabled = NO;
            self.submitBtn.backgroundColor = CA_H_BACKCOLOR;
        }
    }];
    // 添加到达最大限制Block回调
    [_textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        CA_H_StrongSelf(self);
        
    }];
    return _textView;
}
-(CA_MUnderlineTextField *)underlineTxtField{
    if (_underlineTxtField) {
        return _underlineTxtField;
    }
    _underlineTxtField = [[CA_MUnderlineTextField alloc] init];
    _underlineTxtField.underLineColor = CA_H_BACKCOLOR;
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"请填写手机号码，方便我们与您联系"];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, attrString.length)];
    _underlineTxtField.attributedPlaceholder = attrString;
    _underlineTxtField.font = CA_H_FONT_PFSC_Regular(16);
    _underlineTxtField.delegate = self;
    _underlineTxtField.returnKeyType = UIReturnKeyDone;
    return _underlineTxtField;
}
-(UIButton *)submitBtn{
    if (_submitBtn) {
        return _submitBtn;
    }
    _submitBtn = [[UIButton alloc] init];
    [_submitBtn configTitle:@"提交反馈" titleColor:kColor(@"#FFFFFF") font:18];
    _submitBtn.layer.cornerRadius = 2;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = CA_H_BACKCOLOR;
    _submitBtn.enabled = NO;
    [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    return _submitBtn;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [UIView new];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end
