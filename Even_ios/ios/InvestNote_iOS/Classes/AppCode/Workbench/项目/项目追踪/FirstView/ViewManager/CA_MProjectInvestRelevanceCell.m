//
//  CA_MProjectInvestRelevanceCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectInvestRelevanceCell.h"

@implementation CA_MProjectInvestRelevanceCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.bgView];
    self.bgView.sd_layout
    .leftSpaceToView(self.contentView, 15*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH-15*2*CA_H_RATIO_WIDTH*2)
    .heightIs(18*2*CA_H_RATIO_WIDTH);
    
//    [self.bgView addShadowColor:kColor(@"#D8D8D8")
//                withOpacity:0.95
//               shadowRadius:30*2*CA_H_RATIO_WIDTH
//            andCornerRadius:9*2*CA_H_RATIO_WIDTH];

    [self.contentView addSubview:self.messageLb];
    self.messageLb.sd_layout
    .leftSpaceToView(self.contentView, 25*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 14*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.messageLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.closeBtn];
    self.closeBtn.sd_layout
    .leftSpaceToView(self.messageLb, 5*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.messageLb)
    .widthIs(kImage(@"x2").size.width)
    .heightIs(kImage(@"x2").size.height);
}

-(void)closeBtnAction:(UIButton *)sender{
    _closeBlock?_closeBlock():nil;
}

#pragma mark - getter and setter

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#FFFFFF");
        _bgView.layer.cornerRadius = 9*2*CA_H_RATIO_WIDTH;
        _bgView.layer.shadowColor = kColor(@"#D8D8D8").CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 0);
        _bgView.layer.shadowOpacity = 0.5;
        _bgView.layer.shadowRadius = 5;
    }
    return _bgView;
}

-(UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [UILabel new];
        [_messageLb configText:@"项目关联成功！可在项目设置内重新关联"
                     textColor:CA_H_TINTCOLOR
                          font:14];
    }
    return _messageLb;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kImage(@"x2") forState:UIControlStateNormal];
        [_closeBtn addTarget:self
                      action:@selector(closeBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


@end











