//
//  CA_HRemarkCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRemarkCell.h"

@implementation CA_HRemarkCell

#pragma mark --- Action

- (void)setModel:(NSString *)model {
    [super setModel:model];
    
    self.textLabel.text = model.length?model:CA_H_LAN(@"未添加备注");
    [self.textLabel sizeToFit];
    [self setupAutoHeightWithBottomView:self.textLabel bottomMargin:15*CA_H_RATIO_WIDTH];
}

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.imageView.sd_resetLayout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.imageView.superview, 15*CA_H_RATIO_WIDTH);
    self.imageView.image = [UIImage imageNamed:@"remark_icon"];
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.numberOfLines = 0;
    self.textLabel.sd_resetLayout
    .leftSpaceToView(self.imageView, 10*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel.superview, 13*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:300*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
