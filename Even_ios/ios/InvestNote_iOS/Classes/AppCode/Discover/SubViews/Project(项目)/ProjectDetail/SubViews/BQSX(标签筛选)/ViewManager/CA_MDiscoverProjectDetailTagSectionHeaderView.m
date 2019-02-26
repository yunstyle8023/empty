
//
//  CA_MDiscoverProjectDetailTagSectionHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailTagSectionHeaderView.h"

@interface CA_MDiscoverProjectDetailTagSectionHeaderView ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverProjectDetailTagSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
}

-(void)setCount:(NSNumber *)count{
    _count = count;
    NSString *countStr = [NSString stringWithFormat:@"%@",count];
    if (count.intValue >= 1000) {
        countStr = @"1000+";
    }
    NSString *countAttrStr = [NSString stringWithFormat:@"筛选到 %@ %@",countStr,self.title];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:countAttrStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:CA_H_FONT_PFSC_Regular(12)
                    range:NSMakeRange(0, countAttrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:CA_H_9GRAYCOLOR
                    range:NSMakeRange(0, countAttrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:CA_H_TINTCOLOR
                    range:NSMakeRange(4, countStr.length)];
    self.titleLb.attributedText = attrStr;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
    }
    return _titleLb;
}
@end
