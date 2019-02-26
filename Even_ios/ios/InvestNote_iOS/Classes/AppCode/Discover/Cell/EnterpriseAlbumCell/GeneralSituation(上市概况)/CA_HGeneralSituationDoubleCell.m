//
//  CA_HGeneralSituationDoubleCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HGeneralSituationDoubleCell.h"

@interface CA_HGeneralSituationDoubleCell ()

@property (nonatomic, strong) UILabel *nameLeft;
@property (nonatomic, strong) UILabel *contentLeft;
@property (nonatomic, strong) UILabel *nameRight;
@property (nonatomic, strong) UILabel *contentRight;

@end

@implementation CA_HGeneralSituationDoubleCell

#pragma mark --- Action

- (void)setModel:(NSArray *)model {
    
    [super setModel:model];
    
    if (!model.count) {
        _nameLeft.text = nil;
        _contentLeft.text = nil;
        _nameRight.text = nil;
        _contentRight.text = nil;
        [self setupAutoHeightWithBottomView:self.contentView bottomMargin:0];
        return;
    }
    
    if (model.count > 0) {
        self.nameLeft.text = model[0][@"name"];
        self.contentLeft.text = model[0][@"content"];
    }
    if (model.count > 1) {
        self.nameRight.text = model[1][@"name"];
        self.contentRight.text = model[1][@"content"];
        
        [self setupAutoHeightWithBottomViewsArray:@[self.contentLeft, self.contentRight] bottomMargin:20*CA_H_RATIO_WIDTH];
    } else {
        _nameRight.text = nil;
        _contentRight.text = nil;
        [self setupAutoHeightWithBottomView:self.contentLeft bottomMargin:20*CA_H_RATIO_WIDTH];
    }
}

#pragma mark --- Lazy

- (UILabel *)nameLeft {
    if (!_nameLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _nameLeft = label;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .heightIs(17*CA_H_RATIO_WIDTH)
        .topEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 207*CA_H_RATIO_WIDTH);
    }
    return _nameLeft;
}

- (UILabel *)nameRight {
    if (!_nameRight) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _nameRight = label;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .heightIs(17*CA_H_RATIO_WIDTH)
        .topEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 188*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _nameRight;
}

- (UILabel *)contentLeft {
    if (!_contentLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentLeft = label;
        
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .topSpaceToView(self.nameLeft, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:148*CA_H_RATIO_WIDTH];
    }
    return _contentLeft;
}

- (UILabel *)contentRight {
    if (!_contentRight) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentRight = label;
        
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .topSpaceToView(self.nameLeft, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 188*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:167*CA_H_RATIO_WIDTH];
    }
    return _contentRight;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
