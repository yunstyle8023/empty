
//
//  CA_MDiscoverInvestmentCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentCell.h"
#import "CA_MDiscoverInvestmentModel.h"

@interface CA_MDiscoverInvestmentCell ()
@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *areaLb;
@property (nonatomic,strong) UILabel *introLb;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MDiscoverInvestmentCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.areaLb];
    [self.contentView addSubview:self.introLb];
    [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
    
    self.sloganImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 6*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:1];
    
    self.areaLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.areaLb setSingleLineAutoResizeWithMaxWidth:138*2*CA_H_RATIO_WIDTH];
    
    self.introLb.sd_layout
    .leftEqualToView(self.areaLb)
    .topSpaceToView(self.areaLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH);
    [self.introLb setMaxNumberOfLinesToShow:2];
    
    self.lineView.sd_layout
    .leftEqualToView(self.introLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MDiscoverInvestmentData_list *)model{
    [super setModel:model];
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.gp_logo] placeholder:kImage(@"loadfail_project50")];
    self.titleLb.text = model.gp_name;
    self.areaLb.text = [NSString stringWithFormat:@"%@ | %@",[NSString isValueableString:model.area]?model.area:@"暂无",[NSString isValueableString:model.capital_type]?model.capital_type:@"暂无"];
    self.introLb.text = [NSString isValueableString:model.gp_intro]?model.gp_intro:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.introLb bottomMargin:7*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        _introLb.numberOfLines = 2;
        [_introLb configText:@""
                  textColor:CA_H_9GRAYCOLOR
                       font:14];
    }
    return _introLb;
}

-(UILabel *)areaLb{
    if (!_areaLb) {
        _areaLb = [UILabel new];
        [_areaLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _areaLb;
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

-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sloganImgView.layer.borderWidth = 0.5;
        _sloganImgView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
        _sloganImgView.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        _sloganImgView.layer.masksToBounds = YES;
    }
    return _sloganImgView;
}

@end
