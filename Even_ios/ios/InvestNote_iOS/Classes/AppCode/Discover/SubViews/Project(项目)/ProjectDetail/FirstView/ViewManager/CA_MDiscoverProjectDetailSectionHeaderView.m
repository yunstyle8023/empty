
//
//  CA_MDiscoverProjectDetailSectionHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailSectionHeaderView.h"

@interface CA_MDiscoverProjectDetailSectionHeaderView ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *arrowImgView;
@end

@implementation CA_MDiscoverProjectDetailSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraint];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.lineView];
    [self addSubview:self.titleLb];
    [self addSubview:self.arrowImgView];
}

-(void)setConstraint{
    
    self.lineView.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self)
    .heightIs(CA_H_LINE_Thickness);
    
    self.titleLb.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
//    .topSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self)
    .autoHeightRatio(0);
//    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];

    UIImage *image = kImage(@"icons_Details5");
    self.arrowImgView.sd_layout
    .centerYEqualToView(self.titleLb)
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    if ([title rangeOfString:@"（"].location == NSNotFound) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_4BLACKCOLOR range:NSMakeRange(0, title.length)];
        if (self.font) {
            [attStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, title.length)];
        }else{
            [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:NSMakeRange(0, title.length)];
        }
        self.titleLb.attributedText = attStr;
    } else {
        
        NSRange range = [title rangeOfString:@"（"];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_4BLACKCOLOR range:NSMakeRange(0, range.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(range.location, title.length - range.location)];
        
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:NSMakeRange(0, range.location-1)];
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(range.location, title.length - range.location)];
        
        self.titleLb.attributedText = attStr;
    }
    
}

-(void)setShowArrowImg:(BOOL)showArrowImg{
    _showArrowImg = showArrowImg;
    self.arrowImgView.hidden = showArrowImg;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.didSelected) {
        self.didSelected();
    }
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"icons_Details5");
        _arrowImgView.hidden = YES;
    }
    return _arrowImgView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
    }
    return _titleLb;
}

@end
