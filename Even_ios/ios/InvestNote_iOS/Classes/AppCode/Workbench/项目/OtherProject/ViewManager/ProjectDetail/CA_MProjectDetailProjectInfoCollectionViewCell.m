
//
//  CA_MProjectDetailProjectInfoCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MProjectDetailProjectInfoCollectionViewCell ()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MProjectDetailProjectInfoCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView);
        make.leading.mas_equalTo(self.bgView);
        make.trailing.mas_equalTo(self.bgView);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    self.titleLb.font = font;
}

-(void)configCellWithTitleColor:(UIColor*)titleColor
                backgroundColor:(UIColor *)backgroundColor
                    borderColor:(UIColor*)borderColor{
    self.titleLb.textColor = titleColor;
    self.bgView.backgroundColor = backgroundColor;
    _bgView.layer.borderColor = borderColor.CGColor;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [_titleLb configText:@"" textColor:CA_H_TINTCOLOR font:14];
    return _titleLb;
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderColor = CA_H_TINTCOLOR.CGColor;
    _bgView.layer.borderWidth = 0.5;
    return _bgView;
}

@end

