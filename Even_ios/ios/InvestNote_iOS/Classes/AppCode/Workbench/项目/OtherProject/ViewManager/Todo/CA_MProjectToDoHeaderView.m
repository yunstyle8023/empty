
//
//  CA_MProjectToDoHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

typedef enum : NSUInteger {
    UnFinishTag,
    FinishTag
} ButtonTag;

#import "CA_MProjectToDoHeaderView.h"

@interface CA_MProjectToDoHeaderView()
/// 背景
@property(nonatomic,strong)UIView* bgView;
/// 未完成
@property(nonatomic,strong)CA_HSetButton* unfinishBtn;
/// 已完成
@property(nonatomic,strong)CA_HSetButton* finishBtn;
/// currentTag
@property(nonatomic,assign)ButtonTag currentTag;
@end

@implementation CA_MProjectToDoHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = kColor(@"#FFFFFF");
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.unfinishBtn];
    [self addSubview:self.finishBtn];
    self.currentTag = UnFinishTag;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(15);
        make.width.mas_equalTo(335*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(36*CA_H_RATIO_WIDTH);
    }];
    
    [self.unfinishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(32*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self.bgView);
        make.leading.mas_equalTo(self.bgView).offset(1);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(32*CA_H_RATIO_WIDTH);
        make.centerY.mas_equalTo(self.bgView);
        make.trailing.mas_equalTo(self.bgView).offset(-1);
    }];
}

-(void)btnAction:(CA_HSetButton*)sender{
    if (sender.tag == self.currentTag) {
        return;
    }
    self.currentTag = sender.tag;
    BOOL isFinish = NO;
    if (sender.tag == UnFinishTag) {
        self.finishBtn.selected = NO;
        self.finishBtn.backgroundColor = kColor(@"#F8F8F8");
        self.unfinishBtn.selected = YES;
        self.unfinishBtn.backgroundColor = kColor(@"#FFFFFF");
        isFinish = NO;
    }else{
        self.unfinishBtn.selected = NO;
        self.unfinishBtn.backgroundColor = kColor(@"#F8F8F8");
        self.finishBtn.selected = YES;
        self.finishBtn.backgroundColor = kColor(@"#FFFFFF");
        isFinish = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelect:)]) {
        [self.delegate didSelect:isFinish];
    }
}

#pragma mark - getter and setter
-(CA_HSetButton *)finishBtn{
    if (_finishBtn) {
        return _finishBtn;
    }
    _finishBtn = [[CA_HSetButton alloc] init];
    [_finishBtn setTitle:@"已有联系人" forState:UIControlStateNormal];
    [_finishBtn setTitle:@"已有联系人" forState:UIControlStateSelected];
    [_finishBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [_finishBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
    _finishBtn.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    _finishBtn.backgroundColor = kColor(@"#F8F8F8");
    _finishBtn.selected = NO;
    _finishBtn.layer.cornerRadius = 4;
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.tag = FinishTag;
    [_finishBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _finishBtn;
}
-(CA_HSetButton *)unfinishBtn{
    if (_unfinishBtn) {
        return _unfinishBtn;
    }
    _unfinishBtn = [[CA_HSetButton alloc] init];
    [_unfinishBtn setTitle:@"新建联系人" forState:UIControlStateNormal];
    [_unfinishBtn setTitle:@"新建联系人" forState:UIControlStateSelected];
    [_unfinishBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [_unfinishBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
    _unfinishBtn.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    _unfinishBtn.backgroundColor = kColor(@"#FFFFFF");
    _unfinishBtn.selected = YES;
    _unfinishBtn.layer.cornerRadius = 4;
    _unfinishBtn.layer.masksToBounds = YES;
    _unfinishBtn.tag = UnFinishTag;
    [_unfinishBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _unfinishBtn;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#F8F8F8");
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}
@end
