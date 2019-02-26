//
//  CA_MSearchDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailSectionHeaderView.h"

@interface CA_MSearchDetailSectionHeaderView()
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MSearchDetailSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.lineView];
    [self addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self).offset(15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(14);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.lineView.mas_trailing).offset(10);
    }];

}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_TINTCOLOR font:14];
    return _titleLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_TINTCOLOR;
    _lineView.layer.cornerRadius = 0.5;
    _lineView.layer.masksToBounds = YES;
    return _lineView;
}
@end
