
//
//  CA_MDiscoverSponsorCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorCell.h"
#import "CA_MDiscoverTagView.h"
#import "CA_MDiscoverSponsorModel.h"

@interface CA_MDiscoverSponsorCell ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CA_MDiscoverTagView *tagView;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MDiscoverSponsorCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{

    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:1];
    
    self.tagView.sd_layout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.titleLb rightMargin:6];
    
    self.detailLb.sd_layout
    .topSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailLb setMaxNumberOfLinesToShow:2];
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MDiscoverSponsorData_list *)model{
    [super setModel:model];
    
    self.titleLb.text = model.lp_name;

    if ([NSString isValueableString:model.lp_type]) {
        CGFloat typeWidth = [model.lp_type widthForFont:CA_H_FONT_PFSC_Regular(12)];
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-40-typeWidth-3*2*CA_H_RATIO_WIDTH*3];
    }else{
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-40];
    }
    
    self.tagView.hidden = ![NSString isValueableString:model.lp_type];
    self.tagView.titleLb.text = model.lp_type;
    
    self.detailLb.text = [NSString isValueableString:model.lp_intro]?model.lp_intro:@"暂无简介";
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:6*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.numberOfLines = 2;
        [_detailLb configText:@""
                  textColor:CA_H_9GRAYCOLOR
                       font:14];
    }
    return _detailLb;
}
-(CA_MDiscoverTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MDiscoverTagView new];
    }
    return _tagView;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 1;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}
@end
