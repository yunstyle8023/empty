//
//  CA_HBusinessInformationShareholdersCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationShareholdersCell.h"

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationShareholdersCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *proportionLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation CA_HBusinessInformationShareholdersCell

#pragma mark --- Action

- (void)setModel:(CA_HBusinessInformationContentModel *)model {
    [super setModel:model];
    
    self.nameLabel.text = model.stock_name;
    self.proportionLabel.text = model.stock_percent;
    self.typeLabel.text = model.stock_type;
    self.moneyLabel.text = model.should_capi;
    
//    if (model.should_date.doubleValue > 0) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.should_date.doubleValue];
//        self.dateLabel.text = [date stringWithFormat:@"yyyy.MM.dd"];
//    } else {
//        self.dateLabel.text = @"暂无";
//    }
    self.dateLabel.text = model.should_date;
}

#pragma mark --- Lazy

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        _iconImageView = imageView;
        
        imageView.image = [UIImage imageNamed:@"slider_me_hover"];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _typeLabel = label;
    }
    return _typeLabel;
}

- (UILabel *)proportionLabel {
    if (!_proportionLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _proportionLabel = label;
    }
    return _proportionLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _dateLabel = label;
    }
    return _dateLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.sd_layout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.iconImageView)
    .leftSpaceToView(self.contentView, 52*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    UILabel *label0 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label0.text = @"持股比例";
    [self.contentView addSubview:label0];
    label0.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 52*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 42*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.proportionLabel];
    self.proportionLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftEqualToView(label0)
    .topSpaceToView(label0, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label1 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label1.text = @"股东类型";
    [self.contentView addSubview:label1];
    label1.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 220*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 42*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftEqualToView(label1)
    .topSpaceToView(label1, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label2 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label2.text = @"认缴出资额（万元）";
    [self.contentView addSubview:label2];
    label2.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 52*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 111*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftEqualToView(label2)
    .topSpaceToView(label2, 10*CA_H_RATIO_WIDTH);
    
    
    UILabel *label3 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
    label3.text = @"认缴出资日期";
    [self.contentView addSubview:label3];
    label3.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 220*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 111*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.dateLabel];
    self.dateLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(135*CA_H_RATIO_WIDTH)
    .leftEqualToView(label3)
    .topSpaceToView(label3, 10*CA_H_RATIO_WIDTH);
    
}

#pragma mark --- Delegate

@end
