//
//  CA_MFiltrateItemPanelView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemPanelView.h"

@interface CA_MFiltrateItemPanelView ()

@end

@implementation CA_MFiltrateItemPanelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                  CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT-40*2*CA_H_RATIO_WIDTH) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10*2*CA_H_RATIO_WIDTH, 10*2*CA_H_RATIO_WIDTH)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT-40*2*CA_H_RATIO_WIDTH);
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self addSubview:self.titleLb];
        self.titleLb.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, 8*2*CA_H_RATIO_WIDTH)
        .widthIs(CA_H_SCREEN_WIDTH)
        .autoHeightRatio(0);
        
        [self addSubview:self.lineView];
        self.lineView.sd_layout
        .topSpaceToView(self, 27*2*CA_H_RATIO_WIDTH)
        .widthIs(CA_H_SCREEN_WIDTH)
        .heightIs(1*CA_H_RATIO_WIDTH);
        
    }
    return self;
}

#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [_titleLb configText:@"选择行业领域"
                   textColor:CA_H_4BLACKCOLOR
                        font:18];
    }
    return _titleLb;
}

@end
