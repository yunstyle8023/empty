//
//  CA_HRiskSingleCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskSingleCell.h"

@interface CA_HRiskSingleCell ()

@property (nonatomic, strong) UILabel *nameLeft;
@property (nonatomic, strong) UILabel *contentLeft;

@end

@implementation CA_HRiskSingleCell

#pragma mark --- Action

- (void)setModel:(NSArray *)model {
    
    [super setModel:model];
    
    if (!model.count) {
        _nameLeft.text = nil;
        _contentLeft.text = nil;
        [self setupAutoHeightWithBottomView:self.contentView bottomMargin:0];
        return;
    }
    
    if (model.count > 0) {
        self.nameLeft.text = model[0][@"name"];
        self.contentLeft.text = model[0][@"content"];
        [self setupAutoHeightWithBottomView:self.contentLeft bottomMargin:10*CA_H_RATIO_WIDTH];
    }
}

#pragma mark --- Lazy

- (UILabel *)nameLeft {
    if (!_nameLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _nameLeft = label;
        
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        label.sd_layout
        .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:305*CA_H_RATIO_WIDTH];
    }
    return _nameLeft;
}

- (UILabel *)contentLeft {
    if (!_contentLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentLeft = label;
        
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .topSpaceToView(self.nameLeft, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:305*CA_H_RATIO_WIDTH];
    }
    return _contentLeft;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark --- Delegate

@end
