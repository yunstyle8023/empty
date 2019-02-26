

//
//  CA_MDiscoverSponsorItemDetailCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemInvestCell.h"
#import "CA_MDiscoverSponsorItemInvestModel.h"

@interface CA_MDiscoverSponsorItemInvestCell ()

@end

@implementation CA_MDiscoverSponsorItemInvestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [super upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.type];
    [self.contentView addSubview:self.typeLb];
    [self.contentView addSubview:self.invest];
    [self.contentView addSubview:self.investLb];
    [self.contentView addSubview:self.futureMoney];
    [self.contentView addSubview:self.futureMoneyLb];
    [self.contentView addSubview:self.actureMoney];
    [self.contentView addSubview:self.actureMoneyLb];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.lineView];
}

-(void)setConstraints{
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 22*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 7*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    
    UIImage *image = kImage(@"icons_datails7");
    self.arrowImgView.sd_layout
    .topEqualToView(self.titleLb).offset(4)
    .rightSpaceToView(self.titleLb, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    
    self.type.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.type setSingleLineAutoResizeWithMaxWidth:0];
    
    self.typeLb.sd_layout
    .topSpaceToView(self.type, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.type)
    .widthIs(74*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.typeLb setMaxNumberOfLinesToShow:2];
    
    self.invest.sd_layout
    .leftSpaceToView(self.type, 60*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.type)
    .autoHeightRatio(0);
    [self.invest setSingleLineAutoResizeWithMaxWidth:0];
    
    self.investLb.sd_layout
    .topSpaceToView(self.invest, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.invest)
    .widthIs(74*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.investLb setMaxNumberOfLinesToShow:2];
    
    self.futureMoney.sd_layout
    .leftEqualToView(self.typeLb)
    .topSpaceToView(self.typeLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.futureMoney setSingleLineAutoResizeWithMaxWidth:0];
    
    self.futureMoneyLb.sd_layout
    .topSpaceToView(self.futureMoney, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.futureMoney)
    .widthIs(74*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.futureMoneyLb setMaxNumberOfLinesToShow:2];
    
    self.actureMoney.sd_layout
    .leftEqualToView(self.invest)
    .topEqualToView(self.futureMoney)
    .autoHeightRatio(0);
    [self.actureMoney setSingleLineAutoResizeWithMaxWidth:0];
    
    self.actureMoneyLb.sd_layout
    .topSpaceToView(self.actureMoney, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.actureMoney)
    .widthIs(74*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.actureMoneyLb setMaxNumberOfLinesToShow:2];
    
    self.time.sd_layout
    .leftEqualToView(self.futureMoneyLb)
    .topSpaceToView(self.futureMoneyLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.time setSingleLineAutoResizeWithMaxWidth:0];
    
    self.timeLb.sd_layout
    .topSpaceToView(self.time, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.time)
    .widthIs(74*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.timeLb setMaxNumberOfLinesToShow:2];
    
    self.lineView.sd_layout
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 44*CA_H_RATIO_WIDTH)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MDiscoverSponsorItemInvestData_list *)model{
    [super setModel:model];
    
    self.arrowImgView.image = kImage(@"icons_datails7");
    
    self.titleLb.text = model.fund_name;
    
    self.type.text = @"基金类型";
    self.typeLb.text = [NSString isValueableString:model.fund_type]?model.fund_type:@"暂无";
    
    self.invest.text = @"募集轮次";
    self.investLb.text = [NSString isValueableString:model.round]?model.round:@"暂无";
    
    self.futureMoney.text = @"目标规模";
    self.futureMoneyLb.text = [NSString isValueableString:model.target_size]?model.target_size:@"暂无";
    
    self.actureMoney.text = @"承诺金额";
    self.actureMoneyLb.text = [NSString isValueableString:model.promise_amount]?model.promise_amount:@"暂无";
    
    self.time.text = @"出资时间";
    self.timeLb.text = [NSString isValueableString:model.capital_date]?model.capital_date:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.timeLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}


#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView= [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)create4Label{
    return ({
        UILabel *lb = [UILabel new];
        lb.numberOfLines = 0;
        [lb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
        lb;
    });
}
-(UILabel *)create6Label{
    return ({
        UILabel *lb = [UILabel new];
        [lb configText:@"" textColor:CA_H_6GRAYCOLOR font:12];
        lb;
    });
}
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [self create4Label];
    }
    return _timeLb;
}
-(UILabel *)time{
    if (!_time) {
        _time = [self create6Label];
    }
    return _time;
}
-(UILabel *)actureMoneyLb{
    if (!_actureMoneyLb) {
        _actureMoneyLb = [self create4Label];
    }
    return _actureMoneyLb;
}
-(UILabel *)actureMoney{
    if (!_actureMoney) {
        _actureMoney = [self create6Label];
    }
    return _actureMoney;
}
-(UILabel *)futureMoneyLb{
    if (!_futureMoneyLb) {
        _futureMoneyLb = [self create4Label];
    }
    return _futureMoneyLb;
}
-(UILabel *)futureMoney{
    if (!_futureMoney) {
        _futureMoney = [self create6Label];
    }
    return _futureMoney;
}
-(UILabel *)investLb{
    if (!_investLb) {
        _investLb = [self create4Label];
    }
    return _investLb;
}
-(UILabel *)invest{
    if (!_invest) {
        _invest = [self create6Label];
    }
    return _invest;
}
-(UILabel *)typeLb{
    if (!_typeLb) {
        _typeLb = [self create4Label];
    }
    return _typeLb;
}
-(UILabel *)type{
    if (!_type) {
        _type = [self create6Label];
    }
    return _type;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = CA_H_4BLACKCOLOR;
        _titleLb.font = CA_H_FONT_PFSC_Medium(16);
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
    }
    return _arrowImgView;
}
@end
