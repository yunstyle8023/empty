//
//  CA_HInformationModuleCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HInformationModuleCell.h"

#import "CA_HEnterpriseBusinessInfoModel.h"

@interface CA_HInformationModuleCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CA_HInformationModuleCell

#pragma mark --- Action

- (void)setModel:(CA_HEnterpriseModules *)model {
    [super setModel:model];
    
    [self.imageView setImageURL:[NSURL URLWithString:model.module_logo]];
    
    self.titleLabel.text = model.module_name;
    
    if (model.nums) {
        if (model.nums.integerValue > 0) {
            self.countLabel.text = model.nums.stringValue;
            self.countLabel.textColor = CA_H_TINTCOLOR;
            self.titleLabel.textColor = CA_H_4BLACKCOLOR;
        } else {
            self.countLabel.text = @"0";
            self.countLabel.textColor = CA_H_SHADOWCOLOR;
            self.titleLabel.textColor = CA_H_9GRAYCOLOR;
        }
    } else {
        self.countLabel.text = nil;
        self.titleLabel.textColor = CA_H_4BLACKCOLOR;
    }
}

#pragma mark --- Lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
        _titleLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_TINTCOLOR];
        _countLabel = label;
        
        label.textAlignment = NSTextAlignmentRight;
        
        [self.backView addSubview:label];
        label.sd_layout
        .heightIs(17*CA_H_RATIO_WIDTH)
        .widthIs(40*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.backView, 5*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.backView, 8*CA_H_RATIO_WIDTH);
    }
    return _countLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    [self.backView addSubview:self.imageView];
    self.imageView.sd_layout
    .widthIs(48*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.backView);
    
    [self.backView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.backView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 5*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 5*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
