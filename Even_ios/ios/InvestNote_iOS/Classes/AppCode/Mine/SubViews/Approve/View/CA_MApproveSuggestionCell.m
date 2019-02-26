
//
//  CA_MApproveSuggestionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveSuggestionCell.h"
#import "FSTextView.h"

@interface CA_MApproveSuggestionCell ()
<UITextViewDelegate>
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) FSTextView *textView;
@end

@implementation CA_MApproveSuggestionCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.textView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bgView).offset(15);
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(13);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.top.mas_equalTo(self.titleLb.mas_bottom);//.offset(10);
        make.bottom.mas_equalTo(self.bgView);
    }];
}

-(void)configCellTitle:(NSString*)title
                  text:(NSString*)text
           placeholder:(NSString*)placeholder{
    self.titleLb.text = title;
    self.textView.text = text;
    self.textView.placeholder = placeholder;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
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
    _textView.backgroundColor = kColor(@"#F8F8F8");
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
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
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [UIView new];
    _bgView.backgroundColor = kColor(@"#F8F8F8");
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}

@end
