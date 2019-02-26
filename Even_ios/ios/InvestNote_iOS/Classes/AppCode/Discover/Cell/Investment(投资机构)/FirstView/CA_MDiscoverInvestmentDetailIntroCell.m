//
//  CA_MDiscoverInvestmentDetailIntroCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentDetailIntroCell.h"
#import "CA_MDiscoverInvestmentDetailModel.h"

@interface CA_MDiscoverInvestmentDetailIntroCell ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverInvestmentDetailIntroCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    
    self.titleLb.isAttributedContent = YES;
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
}

-(void)setModel:(CA_MDiscoverInvestmentDetailModel *)model{
    [super setModel:model];
    
    self.titleLb.text = [NSString isValueableString:model.base_info.gp_intro]?model.base_info.gp_intro:@"暂无";
    [self.titleLb changeLineSpaceWithSpace:6];
    
    [self setupAutoHeightWithBottomView:self.titleLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
}


-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

@end
