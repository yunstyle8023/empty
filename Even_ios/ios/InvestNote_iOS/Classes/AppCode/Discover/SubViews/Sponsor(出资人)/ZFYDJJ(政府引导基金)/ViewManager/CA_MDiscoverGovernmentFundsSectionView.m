//
//  CA_MDiscoverGovernmentFundsSectionView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverGovernmentFundsSectionView.h"

@interface CA_MDiscoverGovernmentFundsSectionView ()

@property (nonatomic,strong) UILabel *titleLb;

@end

@implementation CA_MDiscoverGovernmentFundsSectionView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLb];
        self.titleLb.sd_layout
        .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self)
        .autoHeightRatio(0);
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    }
    return self;
}

-(void)setTotalCount:(NSNumber *)totalCount{
    _totalCount = totalCount;
    
    NSString *countStr;
    if (totalCount.intValue > 1000) {
        countStr = @"1000+";
    }else {
        countStr = [NSString stringWithFormat:@"%@",totalCount];
    }
    
    NSString *str = [NSString stringWithFormat:@"搜索到 %@ 条出资人",countStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(12) range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(4, countStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(str.length-4, 4)];
    
    self.titleLb.attributedText = attrStr;
    
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
    }
    return _titleLb;
}

@end
