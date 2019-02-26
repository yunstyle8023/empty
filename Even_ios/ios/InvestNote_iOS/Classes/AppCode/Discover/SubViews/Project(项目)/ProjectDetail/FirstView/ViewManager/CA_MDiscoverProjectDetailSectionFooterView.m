
//
//  CA_MDiscoverProjectDetailSectionFooterView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailSectionFooterView.h"

@interface CA_MDiscoverProjectDetailSectionFooterView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) UIView *touchView;
@end

@implementation CA_MDiscoverProjectDetailSectionFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraint];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.arrowImgView];
    [self.bgView addSubview:self.touchView];
}

-(void)setConstraint{
    
    self.titleLb.sd_layout
    .centerYEqualToView(self.bgView)
    .leftSpaceToView(self, 19*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
    UIImage *image = kImage(@"icons_Details");
    self.arrowImgView.sd_layout
    .centerYEqualToView(self.titleLb)
    .leftSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    
    self.bgView.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.arrowImgView).offset(8*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self)
    .heightIs(16*2*CA_H_RATIO_WIDTH);
    //必须是父子UI关系才能使用此方法
    //[self.bgView setupAutoWidthWithRightView:self.arrowImgView rightMargin:0];
    
    self.touchView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

#pragma mark - getter and setter
-(UIView *)touchView{
    if (!_touchView) {
        _touchView = [UIView new];
        _touchView.backgroundColor = [UIColor clearColor];
        CA_H_WeakSelf(self)
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            CA_H_StrongSelf(self)
            if (_pushBlock) {
                _pushBlock();
            }
        }];
        [_touchView addGestureRecognizer:tapGesture];
    }
    return _touchView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#F8F8F8");
        _bgView.layer.cornerRadius = 8*2*CA_H_RATIO_WIDTH;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:14];
    }
    return _titleLb;
}
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"icons_Details");
    }
    return _arrowImgView;
}
@end
