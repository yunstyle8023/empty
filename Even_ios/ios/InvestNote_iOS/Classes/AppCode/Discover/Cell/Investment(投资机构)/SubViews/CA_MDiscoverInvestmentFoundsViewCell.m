
//
//  CA_MDiscoverInvestmentFoundsViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentFoundsViewCell.h"

@interface CA_MDiscoverInvestmentFoundsViewCell ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverInvestmentFoundsViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLb];
        self.titleLb.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        [self.titleLb setMaxNumberOfLinesToShow:0];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        [_titleLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:16];
    }
    return _titleLb;
}

@end
