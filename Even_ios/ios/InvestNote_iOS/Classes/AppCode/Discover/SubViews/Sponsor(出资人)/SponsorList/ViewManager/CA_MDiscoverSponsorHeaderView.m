//
//  CA_MDiscoverSponsorHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorHeaderView.h"
#import "CA_HNoteListTebleView.h"

@implementation CA_MDiscoverSponsorHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.listTableView.headerView];
        
        [self addSubview:self.iconImgView];
        self.iconImgView.sd_layout
        .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.listTableView.headerView, 30*2*CA_H_RATIO_WIDTH+2.5)
        .widthIs(kImage(@"icons_recommend").size.width)
        .heightIs(kImage(@"icons_recommend").size.height);
        
        [self addSubview:self.titleLb];
        self.titleLb.sd_layout
        .leftSpaceToView(self.iconImgView, 3*2*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.iconImgView)
        .autoHeightRatio(0);
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];

        [self addSubview:self.arrowImgView];
        self.arrowImgView.sd_layout
        .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .topEqualToView(self.iconImgView)
        .widthIs(kImage(@"icons_Details").size.width)
        .heightIs(kImage(@"icons_Details").size.height);
        
        [self addSubview:self.touchView];
        self.touchView.sd_layout
        .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.listTableView.headerView, 30*2*CA_H_RATIO_WIDTH+2.5)
        .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .bottomEqualToView(self);
        
        [self addSubview:self.lineView];
        self.lineView.sd_layout
        .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .bottomEqualToView(self)
        .heightIs(CA_H_LINE_Thickness);
        
    }
    return self;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
        _lineView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

-(UIView *)touchView{
    if (!_touchView) {
        _touchView = [UIView new];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            _jumpBlock?_jumpBlock():nil;
        }];
        [_touchView addGestureRecognizer:tapGesture];
    }
    return _touchView;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"icons_Details");
    }
    return _arrowImgView;
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

-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = kImage(@"icons_recommend");
    }
    return _iconImgView;
}

-(CA_HNoteListTebleView *)listTableView{
    if (!_listTableView) {
        _listTableView = [CA_HNoteListTebleView new];
    }
    return _listTableView;
}

@end
