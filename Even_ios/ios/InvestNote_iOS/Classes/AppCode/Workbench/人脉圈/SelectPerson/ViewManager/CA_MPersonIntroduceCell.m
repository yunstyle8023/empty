//
//  CA_MPersonIntroduceCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonIntroduceCell.h"
#import "FSTextView.h"

@interface CA_MPersonIntroduceCell ()
<UITextViewDelegate>
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)FSTextView* textView;
@property(nonatomic,strong)UIView* lineView;
@end

@implementation CA_MPersonIntroduceCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(16);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView).offset(-1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

-(void)configCell:(NSString*)title text:(NSString*)text placeHolder:(NSString*)placeHolder{
    self.titleLb.text = title;
    self.textView.text = text;
    self.textView.placeholder = placeHolder;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}

-(FSTextView *)textView{
    if (_textView) {
        return _textView;
    }
    _textView= [[FSTextView alloc] init];
    _textView.placeholderColor = CA_H_9GRAYCOLOR;
    _textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
    _textView.textColor = CA_H_4BLACKCOLOR;
    _textView.font = CA_H_FONT_PFSC_Regular(16);
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
//    _textView.maxLength = 100;
    CA_H_WeakSelf(self)
    // 添加输入改变Block回调
    [_textView addTextDidChangeHandler:^(FSTextView *textView) {
        CA_H_StrongSelf(self)
        if ([self.delegate respondsToSelector:@selector(textDidChange:)]) {
            [self.delegate textDidChange:textView.text];
        }
    }];
    // 添加到达最大限制Block回调
    [_textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        CA_H_StrongSelf(self)
        if ([self.delegate respondsToSelector:@selector(textLengthDidMax)]) {
            [self.delegate textLengthDidMax];
        }
    }];
    return _textView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}

@end
