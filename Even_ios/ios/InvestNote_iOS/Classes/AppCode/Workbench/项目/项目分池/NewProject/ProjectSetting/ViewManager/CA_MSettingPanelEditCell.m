
//
//  CA_MSettingPanelEditCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingPanelEditCell.h"
#import "CA_MSettingPanelModel.h"

@interface CA_MSettingPanelEditCell ()
@property (nonatomic,strong) UIButton *sortBtn;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UISwitch *switchBtn;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MSettingPanelEditCell

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
    
    [self.contentView addSubview:self.switchBtn];
    self.switchBtn.sd_layout
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightIs(13*2*CA_H_RATIO_WIDTH);
    
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
    self.switchBtn.on = model.is_show;
    
}

-(void)switchBtnAction:(UISwitch *)sender{
//    sender.on = !sender.isOn;
    if (self.switchBlock) self.switchBlock(sender);
}

#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [UISwitch new];
        _switchBtn.onTintColor = CA_H_TINTCOLOR;
        [_switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
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
