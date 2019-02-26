//
//  CA_HBusinessInformationBranchCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationBranchCell.h"

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationBranchCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CA_HBusinessInformationBranchCell

#pragma mark --- Action

- (void)setModel:(CA_HBusinessInformationContentModel *)model {
    [super setModel:model];
    
    self.label.text = model.name;
}

#pragma mark --- Lazy

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_TINTCOLOR];
        _label = label;
        
        label.numberOfLines = 0;
    }
    return _label;
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
    
    [backView addSubview:self.label];
    self.label.sd_layout
    .leftSpaceToView(backView, 27*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 5*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.label setSingleLineAutoResizeWithMaxWidth:298*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:backView];
    backView.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
    [backView setupAutoWidthWithRightView:self.label rightMargin:10*CA_H_RATIO_WIDTH];
    [backView setupAutoHeightWithBottomView:self.label bottomMargin:5*CA_H_RATIO_WIDTH];
    
    
    [self setupAutoHeightWithBottomView:backView bottomMargin:10*CA_H_RATIO_WIDTH];
}

#pragma mark --- Delegate

@end
