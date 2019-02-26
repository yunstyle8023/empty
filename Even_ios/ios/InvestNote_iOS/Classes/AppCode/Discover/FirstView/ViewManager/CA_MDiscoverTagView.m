//
//  CA_MDiscoverTagView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverTagView.h"

@interface CA_MDiscoverTagView ()

@end

@implementation CA_MDiscoverTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
}

-(void)setConstraints{
    
    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.titleLb.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 3*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:12];
    }
    return _titleLb;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#EFF1FF");
        _bgView.layer.cornerRadius = 1*2*CA_H_RATIO_WIDTH;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
