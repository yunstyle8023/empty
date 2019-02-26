//
//  CA_MLimitedCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MLimitedCell.h"
#import "FSTextView.h"

@interface CA_MLimitedCell()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) NSString *textStr;
@property (nonatomic,copy) NSString *placeholderStr;
@property (nonatomic,strong) FSTextView *textView;
@end

@implementation CA_MLimitedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView).offset(-CA_H_LINE_Thickness);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

-(void)setModel:(CA_MTypeModel *)model{
    _model = model;
    self.textView.text = model.value;
    self.textView.placeholder = model.placeHolder;
}

-(void)setMaxLength:(NSInteger)maxLength{
    _maxLength = maxLength;
    self.textView.maxLength = maxLength;
}

-(FSTextView *)textView{
    if (_textView) {
        return _textView;
    }
    _textView= [[FSTextView alloc] init];
    _textView.placeholderColor = CA_H_9GRAYCOLOR;
    _textView.placeholderFont = CA_H_FONT_PFSC_Regular(16);
    _textView.font = CA_H_FONT_PFSC_Regular(16);
    _textView.textColor = CA_H_4BLACKCOLOR;
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
