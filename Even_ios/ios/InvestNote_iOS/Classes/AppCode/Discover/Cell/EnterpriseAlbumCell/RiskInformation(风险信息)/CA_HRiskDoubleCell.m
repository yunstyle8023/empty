//
//  CA_HRiskDoubleCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskDoubleCell.h"

@interface CA_HRiskDoubleCell ()

@property (nonatomic, strong) UILabel *nameLeft;
@property (nonatomic, strong) UILabel *contentLeft;
@property (nonatomic, strong) UILabel *nameRight;
@property (nonatomic, strong) UILabel *contentRight;

@end

@implementation CA_HRiskDoubleCell

#pragma mark --- Action

- (void)setModel:(NSArray *)model {
    
    [super setModel:model];
    

    if (model.count > 0) {
        self.nameLeft.text = [NSString stringWithFormat:@"%@", model[0][@"name"]];
        self.contentLeft.text = [NSString stringWithFormat:@"%@", model[0][@"content"]];
    } else {
        _nameLeft.text = nil;
        _contentLeft.text = nil;
        _nameRight.text = nil;
        _contentRight.text = nil;
        return;
    }
    if (model.count > 1) {
        self.nameRight.text = [NSString stringWithFormat:@"%@", model[1][@"name"]];
        self.contentRight.text = [NSString stringWithFormat:@"%@", model[1][@"content"]];
    } else {
        _nameRight.text = nil;
        _contentRight.text = nil;
    }
}

#pragma mark --- Lazy

- (UILabel *)nameLeft {
    if (!_nameLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _nameLeft = label;
        
        label.numberOfLines = 0;
    }
    return _nameLeft;
}

- (UILabel *)nameRight {
    if (!_nameRight) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_6GRAYCOLOR];
        _nameRight = label;
        
        label.numberOfLines = 0;
    }
    return _nameRight;
}

- (UILabel *)contentLeft {
    if (!_contentLeft) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentLeft = label;
        
        label.numberOfLines = 0;
    }
    return _contentLeft;
}

- (UILabel *)contentRight {
    if (!_contentRight) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _contentRight = label;
        
        label.numberOfLines = 0;
    }
    return _contentRight;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor clearColor];
    
    [topView addSubview:self.nameLeft];
    self.nameLeft.sd_layout
    .topEqualToView(topView)
    .leftEqualToView(topView)
    .autoHeightRatio(0);
    [self.nameLeft setSingleLineAutoResizeWithMaxWidth:148*CA_H_RATIO_WIDTH];
    
    [topView addSubview:self.nameRight];
    self.nameRight.sd_layout
    .topEqualToView(topView)
    .leftSpaceToView(topView, 168*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameRight setSingleLineAutoResizeWithMaxWidth:137*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:topView];
    topView.sd_layout
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH);
    [topView setupAutoHeightWithBottomViewsArray:@[self.nameLeft, self.nameRight] bottomMargin:0];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor clearColor];
    
    [bottomView addSubview:self.contentLeft];
    self.contentLeft.sd_layout
    .topEqualToView(bottomView)
    .leftEqualToView(bottomView)
    .autoHeightRatio(0);
    [self.contentLeft setSingleLineAutoResizeWithMaxWidth:148*CA_H_RATIO_WIDTH];
    
    [bottomView addSubview:self.contentRight];
    self.contentRight.sd_layout
    .topEqualToView(bottomView)
    .leftSpaceToView(bottomView, 168*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentRight setSingleLineAutoResizeWithMaxWidth:137*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:bottomView];
    bottomView.sd_layout
    .topSpaceToView(topView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH);
    [bottomView setupAutoHeightWithBottomViewsArray:@[self.contentLeft, self.contentRight] bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10*CA_H_RATIO_WIDTH];
}

#pragma mark --- Delegate

@end
