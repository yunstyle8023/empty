
//
//  CA_MProjectInvestDynamicCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectInvestDynamicCell.h"
#import "CA_MProjectTraceInvestedModel.h"
#import "ButtonLabel.h"

@implementation CA_MProjectInvestDynamicCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.sloganImgView];
    self.sloganImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .heightIs(23*2*CA_H_RATIO_WIDTH)
    .widthEqualToHeight();
    
    [self.contentView addSubview:self.investorLb];
    self.investorLb.sd_layout
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sloganImgView)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.investorLb setSingleLineAutoResizeWithMaxWidth:[@"投" widthForFont:CA_H_FONT_PFSC_Regular(16)]*5];
    
    [self.contentView addSubview:self.investmentLb];
    self.investmentLb.sd_layout
    .leftSpaceToView(self.investorLb, 3*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.investorLb)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.investmentLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.investoredLb];
    self.investoredLb.sd_layout
    .leftSpaceToView(self.investmentLb, 3*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.investmentLb)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.investoredLb setSingleLineAutoResizeWithMaxWidth:[@"投" widthForFont:CA_H_FONT_PFSC_Regular(16)]*5];
    
    [self.contentView addSubview:self.introduceLb];
    self.introduceLb.sd_layout
    .leftEqualToView(self.investorLb)
    .topSpaceToView(self.investorLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.introduceLb setMaxNumberOfLinesToShow:1];
    
    [self.contentView addSubview:self.newsLb];
    self.newsLb.sd_layout
    .leftEqualToView(self.introduceLb)
    .topSpaceToView(self.introduceLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.newsLb setMaxNumberOfLinesToShow:1];
}

-(void)setModel:(CA_MProjectTraceInvestedModel *)model{
    [super setModel:model];
    NSString *imgUrl;
    if ([model.investor_logo hasPrefix:@"http"]) {
        imgUrl = model.investor_logo;
    }else {
        imgUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.investor_logo];
    }
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kImage(@"loadfail_project50")];
    
    self.investorLb.text = model.investor_name;
    
    self.investmentLb.text = @"投资";
    
    self.investoredLb.text = model.invested_name;
    
    NSString *ts_investedStr = [[NSDate dateWithTimeIntervalSince1970:model.ts_invested.longValue] stringWithFormat:@"yyyy.MM.dd"];
    
    self.introduceLb.text = [NSString stringWithFormat:@"%@  %@  %@",model.round,model.investment_amount,ts_investedStr];
    
    self.newsLb.text = [NSString stringWithFormat:@"相关新闻：%@",model.news_title];
    
    [self setupAutoHeightWithBottomView:self.newsLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter

-(ButtonLabel *)newsLb{
    if (!_newsLb) {
        _newsLb = [ButtonLabel new];
        _newsLb.numberOfLines = 1;
        [_newsLb configText:@""
                       textColor:CA_H_9GRAYCOLOR
                            font:14];
    }
    return _newsLb;
}

-(UILabel *)introduceLb{
    if (!_introduceLb) {
        _introduceLb = [UILabel new];
        _introduceLb.numberOfLines = 1;
        [_introduceLb configText:@""
                       textColor:CA_H_9GRAYCOLOR
                            font:14];
    }
    return _introduceLb;
}

-(ButtonLabel *)investoredLb{
    if (!_investoredLb) {
        _investoredLb = [ButtonLabel new];
        [_investoredLb configText:@""
                      textColor:CA_H_TINTCOLOR
                           font:16];
    }
    return _investoredLb;
}

-(UILabel *)investmentLb{
    if (!_investmentLb) {
        _investmentLb = [UILabel new];
        [_investmentLb configText:@""
                        textColor:CA_H_4BLACKCOLOR
                             font:16];
    }
    return _investmentLb;
}

-(ButtonLabel *)investorLb{
    if (!_investorLb) {
        _investorLb = [ButtonLabel new];
        _investorLb.numberOfLines = 1;
        [_investorLb configText:@""
                      textColor:CA_H_TINTCOLOR
                           font:16];
    }
    return _investorLb;
}

-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sloganImgView.layer.masksToBounds = YES;
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sloganImgView;
}

@end
