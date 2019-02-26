//
//  CA_HFoundProjectListCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundProjectListCell.h"

#import "CA_HFoundSearchModel.h"

@interface CA_HFoundProjectListCell ()

@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation CA_HFoundProjectListCell

#pragma mark --- Action

- (void)setModel:(CA_HFoundSearchDataModel *)model {
    [super setModel:model];
    
    {
        self.nameLabel.attributedText = model.project_name_attributedText;
        [self.nameLabel sizeToFit];
    }
    
    {
        self.contentLabel.attributedText = model.brief_intro_attributedText;
        [self.contentLabel sizeToFit];
    }
    
    {
        NSString *str = [NSString stringWithFormat:@"%@", model.invest_stage?:@""];
        if (str.length) {
            self.tagLabel.superview.hidden = NO;
            self.tagLabel.text = str;
            [self.tagLabel.superview sizeToFit];
        } else {
            self.tagLabel.superview.hidden = YES;
            [self.nameLabel setSingleLineAutoResizeWithMaxWidth:279*CA_H_RATIO_WIDTH];
        }
    }
    
    if (model.project_logo.length) {
        _logoLabel.hidden = YES;
        _logoImageView.hidden = NO;
        [self.logoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.project_logo]] placeholder:[UIImage imageNamed:@"loadfail_project50"]];
    } else {
        _logoImageView.hidden = YES;
        _logoLabel.hidden = NO;
        NSString *name = self.nameLabel.attributedText.string;
        if (name.length) {
            self.logoLabel.text = [name substringToIndex:1];
        } else {
            self.logoLabel.text = @"";
        }
        self.logoLabel.backgroundColor = [UIColor colorWithHexString:model.project_color];
    }
    
    [self.nameLabel sizeToFit];
}

#pragma mark --- Lazy

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImageView *imageView = [UIImageView new];
        _logoImageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:imageView];
        imageView.sd_layout
        .widthIs(45*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        imageView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    }
    return _logoImageView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(20) color:[UIColor whiteColor]];
        _logoLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .widthIs(45*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        label.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    }
    return _logoLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
        label.isAttributedContent = YES;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _contentLabel = label;
        label.isAttributedContent = YES;
    }
    return _contentLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_TINTCOLOR];
        _tagLabel = label;
    }
    return _tagLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 75*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setMaxNumberOfLinesToShow:1];
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:279*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.sd_layout
    .topSpaceToView(self.contentView, 36*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 75*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contentLabel setMaxNumberOfLinesToShow:1];
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:279*CA_H_RATIO_WIDTH];
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = UIColorHex(0xEFF1FF);
    tagView.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
    tagView.layer.masksToBounds = YES;
    
    CA_H_WeakSelf(self);
    tagView.didFinishAutoLayoutBlock = ^(CGRect frame) {
        CA_H_StrongSelf(self);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:274*CA_H_RATIO_WIDTH-frame.size.width];
    };
    
    [tagView addSubview:self.tagLabel];
    self.tagLabel.sd_layout
    .centerYEqualToView(tagView)
    .centerXEqualToView(tagView)
    .autoHeightRatio(0);
    [self.tagLabel setMaxNumberOfLinesToShow:1];
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:80*CA_H_RATIO_WIDTH];
    
    
    [self.contentView addSubview:tagView];
    tagView.sd_layout
    .heightIs(19*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.nameLabel, 5*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.nameLabel);
    [tagView setupAutoWidthWithRightView:self.tagLabel rightMargin:5*CA_H_RATIO_WIDTH];
    
    [CA_HFoundFactoryPattern lineWithView:self left:20*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
