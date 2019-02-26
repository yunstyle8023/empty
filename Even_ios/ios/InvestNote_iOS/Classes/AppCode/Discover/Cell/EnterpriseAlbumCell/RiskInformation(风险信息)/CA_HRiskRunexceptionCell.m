//
//  CA_HRiskRunexceptionCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskRunexceptionCell.h"

@interface CA_HRiskRunexceptionCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation CA_HRiskRunexceptionCell

#pragma mark --- Action

- (void)setModel:(NSDictionary *)model {
    [super setModel:model];
    
    if (![model isKindOfClass:[NSDictionary class]]) return;
    
    self.titleLabel.text = model[@"name"]?:@"";
    self.contentLabel.text = model[@"content"]?:@"";
    self.dateLabel.text = model[@"date"]?:@"";
}

#pragma mark --- Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _titleLabel = label;
        
        [self.contentView addSubview:label];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _dateLabel = label;
        
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentLabel = label;
        
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
    }
    return _contentLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(220*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH);
    
    self.dateLabel.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .widthIs(85*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH);
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.titleLabel, 10*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:305*CA_H_RATIO_WIDTH];
    
    UIView *line = [CA_HFoundFactoryPattern line];
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .topEqualToView(self)
    .leftSpaceToView(self, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 15*CA_H_RATIO_WIDTH);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:11*CA_H_RATIO_WIDTH];
}

#pragma mark --- Delegate

@end
