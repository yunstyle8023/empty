//
//  CA_HForeignInvestmentCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HForeignInvestmentCell.h"

#import "CA_HInvestEventModel.h"

@interface CA_HForeignInvestmentCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *representativeLabel;
@property (nonatomic, strong) UILabel *proportionLabel;

@end

@implementation CA_HForeignInvestmentCell

#pragma mark --- Action

- (void)setModel:(CA_HInvestEventData *)model {
    [super setModel:model];
    
    if ([model isKindOfClass:[CA_HInvestEventData class]]) {
        self.titleLabel.text = model.enterprise_name;
        
        self.moneyLabel.text = model.invest_data_list[0][0][@"content"];
        self.typeLabel.text = model.invest_data_list[0][1][@"content"];
        self.representativeLabel.text = model.invest_data_list[1][0][@"content"];
        self.proportionLabel.text = model.invest_data_list[1][1][@"content"];
    }
}

#pragma mark --- Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _typeLabel = label;
    }
    return _typeLabel;
}

- (UILabel *)representativeLabel {
    if (!_representativeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _representativeLabel = label;
    }
    return _representativeLabel;
}

- (UILabel *)proportionLabel {
    if (!_proportionLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _proportionLabel = label;
    }
    return _proportionLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = CA_H_F8COLOR;
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"icons_datails7"];
    [backView addSubview:imageView];
    imageView.sd_layout
    .widthIs(14*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(backView, 8*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 9*CA_H_RATIO_WIDTH);
    
    [backView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(backView, 27*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 5*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:298*CA_H_RATIO_WIDTH];
    [self.titleLabel setMaxNumberOfLinesToShow:1];
    
    [self.contentView addSubview:backView];
    backView.sd_layout
    .heightIs(32*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
    [backView setupAutoWidthWithRightView:self.titleLabel rightMargin:10*CA_H_RATIO_WIDTH];
    
    
    UILabel *label0 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label0.text = @"注册资本";
    [self.contentView addSubview:label0];
    label0.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 50*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 52*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftEqualToView(label0)
    .topSpaceToView(label0, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label1 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label1.text = @"登记状态";
    [self.contentView addSubview:label1];
    label1.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 218*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 52*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftEqualToView(label1)
    .topSpaceToView(label1, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label2 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label2.text = @"法定代表人";
    [self.contentView addSubview:label2];
    label2.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 50*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 121*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.representativeLabel];
    self.representativeLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftEqualToView(label2)
    .topSpaceToView(label2, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label3 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label3.text = @"出资比例";
    [self.contentView addSubview:label3];
    label3.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 218*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 121*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.proportionLabel];
    self.proportionLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftEqualToView(label3)
    .topSpaceToView(label3, 10*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
