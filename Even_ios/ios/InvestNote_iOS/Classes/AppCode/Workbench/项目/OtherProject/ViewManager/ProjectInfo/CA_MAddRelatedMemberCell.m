//
//  CA_MAddRelatedMemberCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddRelatedMemberCell.h"
#import "FSTextView.h"

@interface CA_MAddRelatedMemberCell()
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UILabel* detailLb;
@property(nonatomic,strong)FSTextView* textView;
@property(nonatomic,strong)UIView* lineView;
@end

@implementation CA_MAddRelatedMemberCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.lineView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb.mas_trailing);
        make.top.mas_equalTo(self.titleLb);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(20);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView).offset(-1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
}

-(void)configCell:(NSString*)text placeHolder:(NSString*)placeHolder{
    self.textView.text = text;
    self.textView.placeholder = placeHolder;
}

#pragma mark - getter and setter
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"关联关系" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"（多种关系请用“、”隔开）" textColor:CA_H_9GRAYCOLOR font:16];
    return _detailLb;
}
-(FSTextView *)textView{
    if (_textView) {
        return _textView;
    }
    _textView= [[FSTextView alloc] init];
    _textView.placeholderColor = CA_H_9GRAYCOLOR;
    _textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
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
