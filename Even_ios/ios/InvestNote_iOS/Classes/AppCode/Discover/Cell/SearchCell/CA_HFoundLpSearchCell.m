//
//  CA_HFoundLpSearchCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundLpSearchCell.h"

#import "CA_HFoundSearchModel.h"

@interface CA_HFoundLpSearchCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation CA_HFoundLpSearchCell

#pragma mark --- Action

- (void)setModel:(CA_HFoundSearchDataModel *)model {
    [super setModel:model];
    
    NSString *tag = model.lp_type;
    
    if (tag.length) {
        
        CGFloat width = [tag widthForFont:CA_H_FONT_PFSC_Regular(12)]+10*CA_H_RATIO_WIDTH;
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:330*CA_H_RATIO_WIDTH-width];
        
        self.tagLabel.text = tag;
        
        self.tagLabel.superview.hidden = NO;
    } else {
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:335*CA_H_RATIO_WIDTH];
        self.tagLabel.superview.hidden = YES;
    }
    
    {
        self.nameLabel.attributedText = model.lp_name_attributedText;
        [self.nameLabel sizeToFit];
    }
    
    {
        self.contentLabel.attributedText = model.lp_intro_attributedText;
        [self.contentLabel sizeToFit];
    }
    
    [self.nameLabel sizeToFit];
}

#pragma mark --- Lazy

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
        
        [self.contentView addSubview:label];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _contentLabel = label;
        
        label.numberOfLines = 2;
        [self.contentView addSubview:label];
    }
    return _contentLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_TINTCOLOR];
        _tagLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setMaxNumberOfLinesToShow:1];
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:335*CA_H_RATIO_WIDTH];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.contentView, 38*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentLabel setMaxNumberOfLinesToShow:2];
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:335*CA_H_RATIO_WIDTH];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorHex(0xEFF1FF);
    backView.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
    backView.layer.masksToBounds = YES;
    
    [backView addSubview:self.tagLabel];
    self.tagLabel.sd_layout
    .centerYEqualToView(backView)
    .leftSpaceToView(backView, 5*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.tagLabel setMaxNumberOfLinesToShow:1];
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:200*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:backView];
    backView.sd_layout
    .heightIs(19*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.nameLabel)
    .leftSpaceToView(self.nameLabel, 5*CA_H_RATIO_WIDTH);
    [backView setupAutoWidthWithRightView:self.tagLabel rightMargin:5*CA_H_RATIO_WIDTH];
//    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:12*CA_H_RATIO_WIDTH];
    
    [CA_HFoundFactoryPattern lineWithView:self left:20*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
