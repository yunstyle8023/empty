//
//  CA_HFoundGpSearchCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundGpSearchCell.h"

#import "CA_HFoundSearchModel.h"

@interface CA_HFoundGpSearchCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation CA_HFoundGpSearchCell

#pragma mark --- Action

- (void)setModel:(CA_HFoundSearchDataModel *)model {
    [super setModel:model];
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.gp_logo] placeholder:[UIImage imageNamed:@"loadfail_project50"]];
    
    {
        self.nameLabel.attributedText = model.gp_name_attributedText;
        [self.nameLabel sizeToFit];
    }
    
    {
        self.tagLabel.attributedText = model.gp_show_attributedText;
        [self.tagLabel sizeToFit];
    }
    
    {
        self.contentLabel.attributedText = model.gp_intro_attributedText;
        [self.contentLabel sizeToFit];
    }
}

#pragma mark --- Lazy

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        _iconImageView = imageView;
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
        imageView.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:imageView];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
        
        label.isAttributedContent = YES;
        [self.contentView addSubview:label];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _contentLabel = label;
        
        label.numberOfLines = 2;
        label.isAttributedContent = YES;
        [self.contentView addSubview:label];
    }
    return _contentLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _tagLabel = label;
        
        label.isAttributedContent = YES;
        [self.contentView addSubview:label];
    }
    return _tagLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.iconImageView.sd_layout
    .widthIs(50*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 12*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setMaxNumberOfLinesToShow:1];
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    self.tagLabel.sd_layout
    .topSpaceToView(self.contentView, 38*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.tagLabel setMaxNumberOfLinesToShow:1];
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.contentView, 62*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentLabel setMaxNumberOfLinesToShow:2];
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    
    [CA_HFoundFactoryPattern lineWithView:self left:20*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
