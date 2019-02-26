//
//  CA_MProjectSelectResultView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectSelectResultView.h"

@interface CA_MProjectSelectResultView()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIButton* cancelBtn;
@end

@implementation CA_MProjectSelectResultView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        [self addSubview:self.bgView];
        [self addSubview:self.titleLb];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self.cancelBtn.mas_leading).offset(-10);
    }];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text =title;
}

- (void)cancelBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cancelClick)]) {
        [self.delegate cancelClick];
    }
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = CA_H_TINTCOLOR;
    _bgView.alpha = 0.05;
    return _bgView;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}

-(UIButton *)cancelBtn{
    if (_cancelBtn) {
        return _cancelBtn;
    }
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn configTitle:@"取消筛选" titleColor:CA_H_TINTCOLOR font:14];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _cancelBtn;
}


@end

