//
//  CA_MProjectProgressTCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressTCollectionViewCell.h"

@interface ProgressTagView :UIView
@property (nonatomic,copy) NSString *title;
@end

@interface ProgressTagView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation ProgressTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = CA_H_F4COLOR;
    _bgView.layer.cornerRadius = 21/2;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    [_titleLb configText:@"" textColor:CA_H_TINTCOLOR font:12];
    return _titleLb;
}
@end

@interface CA_MProjectProgressTCollectionViewCell ()
@property (nonatomic,strong) UIView *circleBgView;
@property (nonatomic,strong) UIView *circleLine;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) ProgressTagView *tagView;
@end

@implementation CA_MProjectProgressTCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.leftLine];
        [self.contentView addSubview:self.rightLine];
        [self.contentView addSubview:self.circleBgView];
        [self.contentView addSubview:self.circleLine];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.tagView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.circleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLb.mas_top).offset(-8);
        make.centerX.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(18);
    }];
    
    [self.circleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.circleBgView);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.circleLine.mas_leading);
        make.centerY.mas_equalTo(self.circleLine);
        make.height.mas_equalTo(1);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.circleLine.mas_trailing);
        make.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.circleLine);
        make.height.mas_equalTo(1);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.circleLine.mas_top).offset(-12);
        make.height.mas_equalTo(20);
    }];
}

-(void)setModel:(CA_Mprocedure_viewModel *)model{
    _model = model;
    self.titleLb.text = model.procedure_name;
    self.circleLine.backgroundColor = kColor(model.procedure_color);
    
    if (model.procedure_id != self.currentID) {
        self.tagView.title = @"";
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        self.tagView.title = model.procedure_status;
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([model.procedure_status widthForFont:CA_H_FONT_PFSC_Regular(12)]+16);
        }];
    }
    
    if (model.procedure_id == self.currentID) {
        self.circleBgView.hidden = NO;
    }else{
        self.circleBgView.hidden = YES;
    }
    
}
-(ProgressTagView *)tagView{
    if (_tagView) {
        return _tagView;
    }
    _tagView = [ProgressTagView new];
    return _tagView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _titleLb;
}
-(UIView *)circleLine{
    if (_circleLine) {
        return _circleLine;
    }
    _circleLine = [UIView new];
    _circleLine.layer.cornerRadius = 6;
    _circleLine.layer.masksToBounds = YES;
    return _circleLine;
}
-(UIView *)circleBgView{
    if (_circleBgView) {
        return _circleBgView;
    }
    _circleBgView = [UIView new];
    _circleBgView.layer.cornerRadius = 9;
    _circleBgView.layer.masksToBounds = YES;
    _circleBgView.backgroundColor = kColor(@"#D3D8F9");
    return _circleBgView;
}
-(UIView *)rightLine{
    if (_rightLine) {
        return _rightLine;
    }
    _rightLine = [UIView new];
    _rightLine.backgroundColor = CA_H_BACKCOLOR;
    return _rightLine;
}
-(UIView *)leftLine{
    if (_leftLine) {
        return _leftLine;
    }
    _leftLine = [UIView new];
    _leftLine.backgroundColor = CA_H_BACKCOLOR;
    return _leftLine;
}
@end
