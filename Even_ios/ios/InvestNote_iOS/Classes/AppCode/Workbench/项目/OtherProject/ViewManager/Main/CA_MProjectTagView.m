
//
//  CA_MProjectTagView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTagView.h"

@implementation CA_MProjectTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = CA_H_TINTCOLOR.CGColor;
    self.layer.borderWidth = 0.5;
    
    [self addSubview:self.lineView];
    
    self.lineView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(2*2*CA_H_RATIO_WIDTH);
    
    [self addSubview:self.tagLb];
    self.tagLb.sd_layout
    .leftSpaceToView(self.lineView, 2*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self)
    .heightIs(9*2*CA_H_RATIO_WIDTH);
    [self.tagLb setSingleLineAutoResizeWithMaxWidth:0];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self);
//        make.top.mas_equalTo(self);
//        make.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(4);
//    }];
//
//    [self.tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self);
//        make.leading.mas_equalTo(self.lineView.mas_trailing).offset(4);
//    }];
//
////    [self mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.trailing.mas_equalTo(self.tagLb.mas_trailing).offset(6);
////    }];
//}

-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_TINTCOLOR;
    return _lineView;
}

-(UILabel *)tagLb{
    if (_tagLb) {
        return _tagLb;
    }
    _tagLb = [[UILabel alloc] init];
    [_tagLb configText:@"" textColor:CA_H_TINTCOLOR font:12];
    return _tagLb;
}


@end
