//
//  CA_MDiscoverSponsorItemInvestCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorItemProjectCell.h"
#import "CA_MDiscoverSponsorItemProjectModel.h"

@interface CA_MDiscoverSponsorItemProjectCell ()
@property (nonatomic,strong) UILabel *ratio;
@property (nonatomic,strong) UILabel *ratioLb;
@end

@implementation CA_MDiscoverSponsorItemProjectCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.ratio];
    [self.contentView addSubview:self.ratioLb];
}

-(void)setConstraints{
    [super setConstraints];
    self.ratio.sd_layout
    .leftEqualToView(self.actureMoney)
    .topEqualToView(self.time)
    .autoHeightRatio(0);
    [self.ratio setSingleLineAutoResizeWithMaxWidth:0];
    
    self.ratioLb.sd_layout
    .leftEqualToView(self.ratio)
    .topSpaceToView(self.ratio, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.ratioLb setSingleLineAutoResizeWithMaxWidth:0];
}

-(void)setModel:(CA_MDiscoverSponsorItemProjectData_list *)model{
    
    self.arrowImgView.image = kImage(@"icons_datails7");
    
    self.titleLb.text = model.project_name;
    
    self.type.text = @"投资方";
    self.typeLb.text = [NSString isValueableString:model.investor_name]?model.investor_name:@"暂无";

    self.invest.text = @"行业";
    self.investLb.text = [NSString isValueableString:model.category]?model.category:@"暂无";

    self.futureMoney.text = @"轮次";
    self.futureMoneyLb.text = [NSString isValueableString:model.round]?model.round:@"暂无";

    self.actureMoney.text = @"投资时间";
    self.actureMoneyLb.text = [NSString isValueableString:model.invest_date]?model.invest_date:@"暂无";

    self.time.text = @"投资金额";
    self.timeLb.text = [NSString isValueableString:model.invest_amount]?model.invest_amount:@"暂无";

    self.ratio.text = @"股权占比(%)";
    self.ratioLb.text = [NSString isValueableString:model.equity_ratio]?model.equity_ratio:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.timeLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

-(UILabel *)ratioLb{
    if (!_ratioLb) {
        _ratioLb = [self create4Label];
    }
    return _ratioLb;
}

-(UILabel *)ratio{
    if (!_ratio) {
        _ratio = [self create6Label];
    }
    return _ratio;
}

@end











