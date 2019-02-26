//
//  CA_HBusinessInformationPersonnelCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationPersonnelCell.h"

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationPersonnelCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *nameRightLabel;
@property (nonatomic, strong) UILabel *positionRightLabel;

@end

@implementation CA_HBusinessInformationPersonnelCell

#pragma mark --- Action

- (void)setModel:(NSArray<CA_HBusinessInformationContentModel *> *)model {
    [super setModel:model];
    
    self.nameLabel.text = model[0].name;
    self.positionLabel.text = model[0].title;
    
    if (model.count > 1) {
        self.nameRightLabel.text = model[1].name;
        self.positionRightLabel.text = model[1].title;
    } else {
        self.nameRightLabel.text = @"";
        self.positionRightLabel.text = @"";
    }
}

#pragma mark --- Lazy

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)nameRightLabel {
    if (!_nameRightLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameRightLabel = label;
    }
    return _nameRightLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _positionLabel = label;
    }
    return _positionLabel;
}

- (UILabel *)positionRightLabel {
    if (!_positionRightLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _positionRightLabel = label;
    }
    return _positionRightLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView);
    
    [self.contentView addSubview:self.positionLabel];
    self.positionLabel.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(148*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 10*CA_H_RATIO_WIDTH);
    
    
    [self.contentView addSubview:self.nameRightLabel];
    self.nameRightLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(167*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 188*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView);
    
    [self.contentView addSubview:self.positionRightLabel];
    self.positionRightLabel.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(167*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 188*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 10*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
