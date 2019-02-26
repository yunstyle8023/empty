
//
//  CA_MDiscoverInvestmentManageFoundsCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentManageFoundsCell ()

@end

@implementation CA_MDiscoverInvestmentManageFoundsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
        [self setConstrains];
    }
    return self;
}

-(void)setupView{
    
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.legal];
    [self.contentView addSubview:self.legalLb];
    [self.contentView addSubview:self.money];
    [self.contentView addSubview:self.moneyLb];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setConstrains{
    
    UIImage *image = kImage(@"icons_datails7");
    self.arrowImgView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 9*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.arrowImgView, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 7*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    
    self.legal.sd_layout
    .leftSpaceToView(self.contentView, 22*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.titleLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.legal setSingleLineAutoResizeWithMaxWidth:0];
    
    self.legalLb.sd_layout
    .leftSpaceToView(self.contentView, 75*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.legal)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.legalLb setMaxNumberOfLinesToShow:0];
    
    self.money.sd_layout
    .leftEqualToView(self.legal)
    .topSpaceToView(self.legalLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.money setSingleLineAutoResizeWithMaxWidth:0];
    
    self.moneyLb.sd_layout
    .leftEqualToView(self.legalLb)
    .centerYEqualToView(self.money)
    .autoHeightRatio(0);
    [self.moneyLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.time.sd_layout
    .leftEqualToView(self.money)
    .topSpaceToView(self.money, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.time setSingleLineAutoResizeWithMaxWidth:0];
    
    self.timeLb.sd_layout
    .leftEqualToView(self.moneyLb)
    .centerYEqualToView(self.time)
    .autoHeightRatio(0);
    [self.timeLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.lineView.sd_layout
    .leftEqualToView(self.titleLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);

}

-(void)setModel:(CA_MDiscoverInvestmentManaged_FundModel *)model{
    [super setModel:model];
    
    self.titleLb.text = model.enterprise_name;
    self.legal.text = @"法定代表人";
    self.legalLb.text = [NSString isValueableString:model.oper_name]?model.oper_name:@"暂无";
    
    if ([NSString isValueableString:model.oper_name]) {
        self.legalLb.textColor = CA_H_TINTCOLOR;
    }else {
        self.legalLb.textColor = CA_H_4BLACKCOLOR;
    }
    
    self.money.text = @"注册资本";
    self.moneyLb.text = [NSString isValueableString:model.regist_capi]?model.regist_capi:@"暂无";
    self.time.text = @"成立日期";
    self.timeLb.text = [NSString isValueableString:model.found_date]?model.found_date:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.timeLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _timeLb;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel new];
        [_time configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _time;
}
-(UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [UILabel new];
        [_moneyLb configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _moneyLb;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel new];
        [_money configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _money;
}
-(ButtonLabel *)legalLb{
    if (!_legalLb) {
        _legalLb = [ButtonLabel new];
        _legalLb.numberOfLines = 0;
        [_legalLb configText:@""
                 textColor:CA_H_TINTCOLOR
                      font:16];
    }
    return _legalLb;
}
-(UILabel *)legal{
    if (!_legal) {
        _legal = [UILabel new];
        [_legal configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _legal;
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
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"icons_datails7");
    }
    return _arrowImgView;
}
@end
