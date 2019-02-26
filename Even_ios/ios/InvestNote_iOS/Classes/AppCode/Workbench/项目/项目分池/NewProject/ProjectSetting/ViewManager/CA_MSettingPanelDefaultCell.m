

//
//  CA_MSettingPanelDefaultCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingPanelDefaultCell.h"
#import "CA_MSettingPanelModel.h"

@interface CA_MSettingPanelDefaultCell ()
@property (nonatomic,strong) UIButton *sortBtn;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *defaultLb;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MSettingPanelDefaultCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.sortBtn];
    self.sortBtn.sd_layout
    .leftSpaceToView(self.contentView, 13*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.contentView)
    .widthIs(kImage(@"move").size.width)
    .heightIs(kImage(@"move").size.height);

    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sortBtn, 8*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.sortBtn)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.defaultLb];
    self.defaultLb.sd_layout
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.defaultLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.sortBtn)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MSettingPanelModel *)model{
    [super setModel:model];
    
    self.titleLb.text = model.split_pool_name;
    self.defaultLb.text = @"默认展开";
    
}

#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)defaultLb{
    if (!_defaultLb) {
        _defaultLb = [UILabel new];
        [_defaultLb configText:@""
                     textColor:CA_H_9GRAYCOLOR
                          font:14];
    }
    return _defaultLb;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

-(UIButton *)sortBtn{
    if (!_sortBtn) {
        _sortBtn = [UIButton new];
        _sortBtn.enabled = NO;
        [_sortBtn setImage:kImage(@"move") forState:UIControlStateNormal];
    }
    return _sortBtn;
}

@end
