//
//  CA_MProjectNoTraceCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectNoTraceCell.h"

@interface CA_MProjectNoTraceCell ()

@end

@implementation CA_MProjectNoTraceCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.bgView];
    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 10*2*CA_H_RATIO_WIDTH, 0, 10*2*CA_H_RATIO_WIDTH));
    
    [self.contentView addSubview:self.messageLb];
    self.messageLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.contentView)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
}

#pragma mark - getter and setter

-(UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [UILabel new];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        [_messageLb configText:@"暂无相关项目"
                     textColor:CA_H_9GRAYCOLOR
                          font:14];
    }
    return _messageLb;
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







