//
//  CA_MDiscoverSponsorDetailBottomView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailBottomView.h"

@interface CA_MDiscoverSponsorDetailBottomView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *lookBtn;
@end

@implementation CA_MDiscoverSponsorDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstrains];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.bgView];
    [self addSubview:self.lookBtn];
}

-(void)setConstrains{
    self.lookBtn.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

-(void)setCount:(NSNumber *)count{
    _count = count;
    
    self.lookBtn.enabled = (count.intValue == 0) ? NO : YES;
    
    NSString *str = [NSString stringWithFormat:@"查看联系方式（今天还剩 %@ 次机会）",count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, 6)];
    [attr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(6, str.length-6)];
    [attr addAttribute:NSForegroundColorAttributeName value:(self.lookBtn.isEnabled?CA_H_TINTCOLOR:CA_H_9GRAYCOLOR) range:NSMakeRange(0, 6)];
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(6, 5)];
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(11, str.length-16)];
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(str.length-3-1, 3)];
    
    [self.lookBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

-(void)setIsLook:(BOOL)isLook{
    _isLook = isLook;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"查看联系方式"];
    [attr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, 6)];
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(0, 6)];
    [_lookBtn setAttributedTitle:attr forState:UIControlStateNormal];
}

-(void)lookBtnAction{
    if (self.selectBlock) {
        self.selectBlock();
    }
}

#pragma mark - getter and setter

-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton new];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"查看联系方式"];
        [attr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, 6)];
        [attr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(0, 6)];
        [_lookBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_lookBtn addTarget:self action:@selector(lookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGRect rect = CGRectMake(0, 3, CA_H_SCREEN_WIDTH, 25*2*CA_H_RATIO_WIDTH-3);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = kColor(@"#FCFCFC");
    [CA_HShadow dropShadowWithView:_bgView
                            offset:CGSizeMake(0, -3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    return _bgView;
}
@end
