//
//  CA_HMineCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineCell.h"

@interface CA_HMineCell ()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CA_HMineCell

#pragma mark --- Action

- (void)setModel:(NSNumber *)model {
    [super setModel:model];
    
    if (model.integerValue) {
        self.countLabel.text = model.stringValue;
        self.countLabel.sd_layout
        .widthIs(MAX([self.countLabel.text widthForFont:CA_H_FONT_PFSC_Regular(14)]+10*CA_H_RATIO_WIDTH, 19*CA_H_RATIO_WIDTH));
    } else {
        self.countLabel.sd_layout
        .widthIs(0);
    }
}

#pragma mark --- Lazy

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *label = [UILabel new];
        _countLabel = label;
        
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = CA_H_69REDCOLOR;
        label.font = CA_H_FONT_PFSC_Regular(12);
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .heightIs(19*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .widthIs(0);
        label.sd_cornerRadiusFromHeightRatio = @(0.5);
    }
    return _countLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.imageView.sd_resetLayout
    .centerYEqualToView(self.imageView.superview)
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.textLabel.numberOfLines = 1;
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.sd_resetLayout
    .leftSpaceToView(self.imageView, 10*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel.superview, 15*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:280*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
//    .leftEqualToView(self.imageView);
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
