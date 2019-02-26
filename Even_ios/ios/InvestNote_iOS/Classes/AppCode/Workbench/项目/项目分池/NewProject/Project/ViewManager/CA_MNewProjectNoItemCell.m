//
//  CA_MNewProjectNoItemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectNoItemCell.h"

@interface CA_MNewProjectNoItemCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *msgLb;
@end

@implementation CA_MNewProjectNoItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        self.bgView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(10*2*CA_H_RATIO_WIDTH, 0, 0, 0));
        
        [self.contentView addSubview:self.msgLb];
        self.msgLb.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .centerYEqualToView(self.bgView)
        .heightIs(10*2*CA_H_RATIO_WIDTH);
    }
    return self;
}

-(UILabel *)msgLb{
    if (!_msgLb) {
        _msgLb = [UILabel new];
        _msgLb.textAlignment = NSTextAlignmentCenter;
        [_msgLb configText:@"暂无相关项目"
                 textColor:CA_H_9GRAYCOLOR
                      font:14];
    }
    return _msgLb;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#F8F8F8");
        _bgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
