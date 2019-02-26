//
//  CA_MCustomTextFieldView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCustomTextFieldView.h"
#import "CA_MCustomAccessoryView.h"

@implementation CA_MCustomTextFieldView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        [self addSubview:self.txtField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.txtField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(4);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH - 20*2);
    }];
}

- (void)textFieldDidChangeValue:(UITextField*)txtField{
    if (self.deleagte &&
        [self.deleagte respondsToSelector:@selector(textDidChange:)]) {
        [self.deleagte textDidChange:txtField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardWillBeHiden{
    if (self.deleagte &&
        [self.deleagte respondsToSelector:@selector(keyboradChange)]) {
        [self.deleagte keyboradChange];
    }
}

-(CA_MCustomAccessoryView *)accessoryView{
    if (_accessoryView) {
        return _accessoryView;
    }
    _accessoryView = [[CA_MCustomAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 44)];
    CA_H_WeakSelf(self)
    _accessoryView.tapBlock = ^{
        CA_H_StrongSelf(self)
        if (self.deleagte && [self.deleagte respondsToSelector:@selector(jump2AddProject)]) {
            [self.deleagte jump2AddProject];
        }
    };
    return _accessoryView;
}
-(UITextField *)txtField{
    if (_txtField) {
        return _txtField;
    }
    _txtField = [[UITextField alloc] init];
    NSString* placeholder = @"请填写项目名称";
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:NSMakeRange(0, placeholder.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, placeholder.length)];
    _txtField.attributedPlaceholder = attStr;
    _txtField.inputAccessoryView = self.accessoryView;
    _txtField.inputAccessoryView.hidden = YES;
    [_txtField addTarget:self
                  action:@selector(textFieldDidChangeValue:)
        forControlEvents:UIControlEventEditingChanged];
    _txtField.returnKeyType = UIReturnKeyDone;
    _txtField.delegate = self;
    return _txtField;
}

@end
