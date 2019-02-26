//
//  CA_HBusinessInformationBasicCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationBasicCell.h"

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationBasicCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CA_HBusinessInformationBasicCell

#pragma mark --- Action

- (void)setModel:(CA_HBusinessInformationContentModel *)model {
    [super setModel:model];
    
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
}

#pragma mark --- Lazy

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
        
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
        _contentLabel = label;
        
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIView *)topLine {
    if (!_topLine) {
        UIView *line = [UIView new];
        _topLine = line;
        
        line.backgroundColor = CA_H_DCOLOR;
        [self addSubview:line];
        line.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .topEqualToView(self)
        .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
    }
    return _topLine;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = CA_H_F8COLOR;
    [self addSubview:backView];
    backView.sd_layout
    .widthIs(116*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    NSArray *xArray = @[@20,@136,@354];
    for (NSNumber *left in xArray) {
        CGFloat x = left.doubleValue*CA_H_RATIO_WIDTH;
        UIView *line = [UIView new];
        line.backgroundColor = CA_H_DCOLOR;
        [self addSubview:line];
        line.sd_layout
        .widthIs(CA_H_LINE_Thickness)
        .leftSpaceToView(self, x)
        .topEqualToView(self)
        .bottomEqualToView(self);
    }
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_DCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
    
    
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .centerXIs(78*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:96*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .centerXIs(245*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:198*CA_H_RATIO_WIDTH];
    
    [self sendSubviewToBack:backView];
//    [self setupAutoHeightWithBottomViewsArray:@[self.nameLabel, self.contentLabel] bottomMargin:10*CA_H_RATIO_WIDTH];
}

#pragma mark --- Delegate

@end
