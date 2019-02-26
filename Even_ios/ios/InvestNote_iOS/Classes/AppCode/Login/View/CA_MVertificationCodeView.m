//
//  CA_M_VertificationCodeView.m
//  ceshi
//
//  Created by yezhuge on 2017/11/19.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MVertificationCodeView.h"
#import "CA_MVertificationCodeLabel.h"

@interface CA_MVertificationCodeView()<UITextFieldDelegate>
/// 用于获取键盘输入的内容,实际不显示
@property(nonatomic,strong)UITextField* textField;
/// 验证码/密码输入框的背景图片
@property(nonatomic,strong)UIImageView* backgroundImageView;
/// 实际用于显示验证码/密码的label
@property(nonatomic,strong)CA_MVertificationCodeLabel* label;
@end

@implementation CA_MVertificationCodeView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置透明背景色,保证vertificationCodeView显示的frame为backgroundImageView的frame
        self.backgroundColor = [UIColor clearColor];
        // 设置验证码/密码的位数默认为四位
        self.numberOfVertificationCode =4;
        [self setupUI];
    }
    return self;
}

/**
 约束控件的布局
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textField.frame = self.bounds;
    self.label.frame = self.bounds;
}

#pragma mark - Private

/**
 调用键盘,成为第一响应者
 */
- (void)becomeFirstResponder{
    [self.textField becomeFirstResponder];
}

/**
 调用键盘,成为第一响应者
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField becomeFirstResponder];
}

/**
 添加控件
 */
- (void)setupUI{
    [self insertSubview:self.textField atIndex:0];
    [self addSubview:self.label];
}

/**
 设置背景图片

 @param backgroudImageName <#backgroudImageName description#>
 */
- (void)setBackgroudImageName:(NSString *)backgroudImageName {
    _backgroudImageName = backgroudImageName;
    // 若用户设置了背景图片,则添加背景图片
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backgroundImageView.image = kImage(self.backgroudImageName);
    // 将背景图片插入到label的后边,避免遮挡验证码/密码的显示
    [self insertSubview:self.backgroundImageView belowSubview:self.label];
}

/**
 设置验证码/密码个数

 @param numberOfVertificationCode numberOfVertificationCode description
 */
- (void)setNumberOfVertificationCode:(NSInteger)numberOfVertificationCode {
    _numberOfVertificationCode = numberOfVertificationCode;
    // 保持label的验证码/密码位数与IDVertificationCodeView一致,此时label一定已经被创建
    self.label.numberOfVertificationCode =_numberOfVertificationCode;
}

/**
 设置验证码/密码是否是密码显示形式,小圆点显示

 @param secureTextEntry <#secureTextEntry description#>
 */
- (void)setSecureTextEntry:(bool)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    self.label.secureTextEntry =_secureTextEntry;
}

-(void)cleanVertificationCode{
    self.label.text = @"";
    [self.label setNeedsDisplay];
    self.textField.text = @"";
//    self.label.firstResponder = YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.label.firstResponder = YES;
    [self.label setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.label.firstResponder = NO;
    [self.label setNeedsDisplay];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    // 判断是不是“删除”字符
    if (string.length != 0) {//不是“删除”字符
        self.label.isDelete = NO;
        // 判断验证码/密码的位数是否达到预定的位数
        if (textField.text.length < self.numberOfVertificationCode) {
            self.label.text = [textField.text stringByAppendingString:string];
            self.vertificationCode = self.label.text;
            if (self.label.text.length == self.numberOfVertificationCode) {
                NSLog(@"已经输入完成验证码了vertificationCode= %@",_vertificationCode);
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishVertificationCode:)]) {
                    [self.delegate didFinishVertificationCode:self.vertificationCode];
                }
            }
            return YES;
        } else {
            return NO;
        }
    } else {//是“删除”字符
        if (textField.text.length != 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVertificationCode:)]) {
                [self.delegate deleteVertificationCode:self.vertificationCode];
            }
            self.label.isDelete = YES;
            self.label.text = [textField.text substringToIndex:textField.text.length -1];
            self.vertificationCode = self.label.text;
            return YES;
        }
        return NO;
    }
}

#pragma mark - Getter and Setter
-(CA_MVertificationCodeLabel *)label{
    if (_label) {
        return _label;
    }
    // 添加用于显示验证码/密码的label
    _label = [[CA_MVertificationCodeLabel alloc]init];
    _label.numberOfVertificationCode = self.numberOfVertificationCode;
    _label.secureTextEntry = self.secureTextEntry;
    _label.font = self.textField.font;
    return _label;
}

-(UITextField *)textField{
    if (_textField) {
        return _textField;
    }
    // 调出键盘的textField
    _textField = [[UITextField alloc]init];
    // 隐藏textField,通过点击IDVertificationCodeView使其成为第一响应者,来弹出键盘
    _textField.hidden =YES;
    _textField.keyboardType =UIKeyboardTypeNumberPad;
    _textField.delegate =self;
    return _textField;
}

@end
