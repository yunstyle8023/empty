//
//  CA_HEditMenuCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HEditMenuCell.h"

@interface CA_HEditMenuCell ()

@end

@implementation CA_HEditMenuCell

#pragma mark --- LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)upView{
    
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout
    .widthIs(45*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 15*CA_H_RATIO_WIDTH);
    
    _textLabel = [UILabel new];
    _textLabel.font = CA_H_FONT_PFSC_Regular(12);
    _textLabel.textColor = CA_H_9GRAYCOLOR;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLabel];
    _textLabel.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .autoHeightRatio(0);
}

@end
