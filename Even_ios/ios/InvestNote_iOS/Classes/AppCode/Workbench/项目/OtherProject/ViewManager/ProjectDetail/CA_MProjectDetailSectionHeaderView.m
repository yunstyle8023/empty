//
//  CA_MProjectDetailSectionHeaderView.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailSectionHeaderView.h"

@interface CA_MProjectDetailSectionHeaderView()
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIButton* editBtn;
@end

@implementation CA_MProjectDetailSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.lineView];
    [self addSubview:self.titleLb];
    [self addSubview:self.editBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(20);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    
}

-(void)configTitle:(NSString *)title isHiddenEditBtn:(BOOL)isHidden{
    self.titleLb.text = title;
    self.editBtn.hidden = isHidden;
}

-(void)editBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editClick:)]) {
        [self.delegate editClick:self.titleLb.text];
    }
}

#pragma mark - getter and setter
-(UIButton *)editBtn{
    if (_editBtn) {
        return _editBtn;
    }
    _editBtn = [[UIButton alloc] init];
    [_editBtn setImage:kImage(@"edit_icon") forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _editBtn;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:18];
    return _titleLb;
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
