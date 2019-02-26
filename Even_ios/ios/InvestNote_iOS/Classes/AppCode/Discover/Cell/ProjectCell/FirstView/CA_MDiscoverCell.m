//
//  CA_MDiscoverCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverCell.h"
#import "CA_MDiscoverTagView.h"
#import "CA_MDiscoverModel.h"
#import "CA_HShowDate.h"

@interface CA_MDiscoverCell ()

@end

@implementation CA_MDiscoverCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.moneyLb];
    [self.contentView addSubview:self.organizationLb];
    [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
    
    self.sloganImgView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.titleLb.sd_resetLayout
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, (3.5)*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:1];

    self.tagView.sd_resetLayout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.titleLb rightMargin:6];

    self.timeLb.sd_resetLayout
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .autoHeightRatio(0);
    [self.timeLb setSingleLineAutoResizeWithMaxWidth:0];

    self.moneyLb.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 4*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.moneyLb setMaxNumberOfLinesToShow:1];

    self.organizationLb.sd_resetLayout
    .leftEqualToView(self.moneyLb)
    .topSpaceToView(self.moneyLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.organizationLb setMaxNumberOfLinesToShow:1];
    
    self.lineView.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MCommonModel *)model{
    [super setModel:model];
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    self.tagView.titleLb.text = model.invest_round;
    
    self.tagView.hidden = ![NSString isValueableString:model.invest_round];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.invest_date.longValue];
    self.timeLb.text = [CA_HShowDate showDateWithoutTime:date];
    
    self.moneyLb.text = [NSString stringWithFormat:@"融资金额：%@",[NSString isValueableString:model.invest_money]?model.invest_money:@"暂无"];
    
    self.organizationLb.text = [NSString stringWithFormat:@"投资机构：%@",[NSString isValueableString:model.investor]?model.investor:@"暂无"];
    
    CGFloat margin = 3*2*CA_H_RATIO_WIDTH;
    
    CGFloat timeWidth = [self.timeLb.text widthForFont:CA_H_FONT_PFSC_Regular(12)] + margin;
    
    CGFloat remindWidth = CA_H_SCREEN_WIDTH-(10+25+5+10)*2*CA_H_RATIO_WIDTH;
    
    if ([NSString isValueableString:model.invest_round]) {
        CGFloat roundWidth = [model.invest_round widthForFont:CA_H_FONT_PFSC_Regular(12)]+margin*2;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:(remindWidth-roundWidth-timeWidth-margin*2)];
    }else{
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:(remindWidth-timeWidth-margin*2)];
    }

    [self setupAutoHeightWithBottomView:self.organizationLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)organizationLb{
    if (!_organizationLb) {
        _organizationLb = [UILabel new];
        _organizationLb.numberOfLines = 1;
        [_organizationLb configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:14];
    }
    return _organizationLb;
}
-(UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [UILabel new];
        [_moneyLb configText:@""
                  textColor:CA_H_6GRAYCOLOR
                       font:14];
    }
    return _moneyLb;
}
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:12];
    }
    return _timeLb;
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
                   textColor:CA_H_TINTCOLOR
                        font:16];
    }
    return _titleLb;
}
-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sloganImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sloganImgView.layer.masksToBounds = YES;
    }
    return _sloganImgView;
}
@end
