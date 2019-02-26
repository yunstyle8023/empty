
//
//  CA_MDiscoverInvestmentCommerceCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentCommerceCell.h"
#import "CA_MDiscoverInvestmentFoundsViewCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentCommerceCell ()

@property (nonatomic,strong) UIView *verLineView;
//@property (nonatomic,strong) ButtonLabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *company;
//@property (nonatomic,strong) ButtonLabel *companyLb;
@property (nonatomic,strong) UIView *horLineView;
@end

@implementation CA_MDiscoverInvestmentCommerceCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.verLineView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.company];
    [self.contentView addSubview:self.companyLb];
    [self.contentView addSubview:self.horLineView];
    [self setConstrains];
}

-(void)setConstrains{
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 20*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 7*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    
    self.timeLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.timeLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.company.sd_layout
    .leftEqualToView(self.timeLb)
    .topSpaceToView(self.timeLb, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.company setSingleLineAutoResizeWithMaxWidth:0];
    
    self.verLineView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 9*2*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.company, -2*2*CA_H_RATIO_WIDTH)
    .widthIs(2*2*CA_H_RATIO_WIDTH);

    self.companyLb.sd_layout
    .leftSpaceToView(self.company, 0)
    .topEqualToView(self.company)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.companyLb setMaxNumberOfLinesToShow:0];

    self.horLineView.sd_layout
    .leftEqualToView(self.company)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MDiscoverInvestmentBusiness_TraceModel *)model{
    [super setModel:model];
    
    self.titleLb.text = model.invest_enterprise;
    self.timeLb.text = [NSString isValueableString:model.invest_date]?model.invest_date:@"暂无";
    self.company.text = @"对外投资：";
    self.companyLb.text = [NSString isValueableString:model.invested_enterprise]?model.invested_enterprise:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.companyLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter

-(UIView *)horLineView{
    if (!_horLineView) {
        _horLineView = [UIView new];
        _horLineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _horLineView;
}
-(ButtonLabel *)companyLb{
    if (!_companyLb) {
        _companyLb = [ButtonLabel new];
        _companyLb.numberOfLines = 0;
        [_companyLb configText:@""
                     textColor:CA_H_TINTCOLOR
                          font:14];
    }
    return _companyLb;
}
-(UILabel *)company{
    if (!_company) {
        _company = [UILabel new];
        [_company configText:@""
                  textColor:CA_H_4BLACKCOLOR
                       font:14];
    }
    return _company;
}
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                  textColor:CA_H_4BLACKCOLOR
                       font:14];
    }
    return _timeLb;
}
-(ButtonLabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [ButtonLabel new];
        _titleLb.font = CA_H_FONT_PFSC_Medium(16);
        _titleLb.textColor = CA_H_TINTCOLOR;
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
-(UIView *)verLineView{
    if (!_verLineView) {
        _verLineView = [UIView new];
        _verLineView.backgroundColor = kColor(@"#F4F4F4");
    }
    return _verLineView;
}
@end
