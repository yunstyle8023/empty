
//
//  CA_MDiscoverProjectCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectCell.h"
#import "CA_MDiscoverTagView.h"
#import "CA_MDiscoverModel.h"
#import "CA_HShowDate.h"

@interface CA_MDiscoverProjectCell ()
@property (nonatomic,strong) UILabel *companyLb;
@end

@implementation CA_MDiscoverProjectCell

-(void)upView{
    [self.contentView addSubview:self.companyLb];
    [super upView];
}

-(void)setConstraints{
//    [super setConstraints];
    
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

    self.companyLb.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.moneyLb, 4)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.companyLb setMaxNumberOfLinesToShow:1];

    self.organizationLb.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.companyLb, 2*2*CA_H_RATIO_WIDTH)
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
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    self.tagView.titleLb.text = model.invest_round;
    
    self.tagView.hidden = ![NSString isValueableString:model.invest_round];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.invest_date.longValue];
    
    self.timeLb.text = [CA_HShowDate showDateWithoutTime:date];
    
    self.moneyLb.text = [NSString stringWithFormat:@"融资金额: %@",[NSString isValueableString:model.invest_money]?model.invest_money:@"暂无"];
    
    self.companyLb.text = [NSString stringWithFormat:@"所属公司: %@",[NSString isValueableString:model.enterprise_name]?model.enterprise_name:@"暂无"];
    
    self.organizationLb.text = [NSString stringWithFormat:@"投资机构: %@",[NSString isValueableString:model.investor]?model.investor:@"暂无"];
    
    CGFloat margin = 3*2*CA_H_RATIO_WIDTH;
    
    CGFloat timeWidth = [self.timeLb.text widthForFont:CA_H_FONT_PFSC_Regular(12)] + margin;
    
    CGFloat remindWidth = CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH+25*2*CA_H_RATIO_WIDTH+5*2*CA_H_RATIO_WIDTH+10*2*CA_H_RATIO_WIDTH);
    
    if ([NSString isValueableString:model.invest_round]) {
        CGFloat roundWidth = [model.invest_round widthForFont:CA_H_FONT_PFSC_Regular(12)]+margin*2;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:(remindWidth-timeWidth-roundWidth-margin*2)];
    }else{
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:(remindWidth-timeWidth-margin)];
    }
    
    [self setupAutoHeightWithBottomView:self.organizationLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
    
}

-(UILabel *)companyLb{
    if (!_companyLb) {
        _companyLb = [UILabel new];
        [_companyLb configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:14];
    }
    return _companyLb;
}
@end
