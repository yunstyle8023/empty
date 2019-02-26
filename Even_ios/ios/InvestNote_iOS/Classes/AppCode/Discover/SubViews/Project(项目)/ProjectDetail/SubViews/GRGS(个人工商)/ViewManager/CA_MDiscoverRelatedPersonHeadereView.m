//
//  CA_MDiscoverRelatedPersonHeadereView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonHeadereView.h"

@interface CA_MDiscoverRelatedPersonHeadereView ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverRelatedPersonHeadereView

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

-(void)setTitle:(NSString *)title{
    _title = title;
    
    NSString *str = [NSString stringWithFormat:@"共有 %@ 条信息",title];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(12) range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(3, title.length)];
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
