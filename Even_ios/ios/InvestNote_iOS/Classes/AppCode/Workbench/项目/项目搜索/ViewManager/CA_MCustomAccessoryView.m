//
//  CA_MCustomAccessoryView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCustomAccessoryView.h"

@implementation CA_MCustomAccessoryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.arrowImgView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-13);
    }];
    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb.mas_trailing);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb).offset(-20);
        make.trailing.mas_equalTo(self.arrowImgView.mas_trailing).offset(20);
        make.top.mas_equalTo(self.titleLb.mas_top).offset(-5);
        make.bottom.mas_equalTo(self.titleLb.mas_bottom).offset(5);
    }];
    [self.bgView addShadowColor:kColor(@"#D8D8D8")
                    withOpacity:0.5
                   shadowRadius:3
                andCornerRadius:13];
}
-(void)tapGestureAction{
    !_tapBlock?:_tapBlock();
}
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"shape");
    return _arrowImgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    NSString* title = @"没找到想要的？手动录入";
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(0, title.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, 7)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(7, title.length-7)];
    _titleLb.attributedText = attStr;
    [_titleLb sizeToFit];
    return _titleLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_bgView addGestureRecognizer:tapGesture];
    return _bgView;
}

@end
