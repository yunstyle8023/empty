//
//  CA_HSettingsCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSettingsCell.h"

@interface CA_HSettingsCell ()

@end

@implementation CA_HSettingsCell

#pragma mark --- Action

- (void)setModel:(NSObject *)model {
    [super setModel:model];
    
    
}

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    [super upView];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.textLabel.numberOfLines = 1;
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.sd_resetLayout
    .leftSpaceToView(self.textLabel.superview, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel.superview, 15*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.numberOfLines = 1;
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    self.detailTextLabel.sd_resetLayout
    .rightEqualToView(self.detailTextLabel.superview)
    .centerYEqualToView(self.textLabel)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:200*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
