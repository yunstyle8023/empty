//
//  CA_HFoundReportCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundReportCell.h"

#import "CA_HFoundReportModel.h"

@interface CA_HFoundReportCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *downImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation CA_HFoundReportCell

#pragma mark --- Action

- (void)setModel:(CA_HFoundReportData *)model {
    [super setModel:model];
    
    if (model.saved) {
        [self.placeholderLabel setSingleLineAutoResizeWithMaxWidth:23*CA_H_RATIO_WIDTH];
        self.downImageView.hidden = NO;
    } else {
        self.downImageView.hidden = YES;
        [self.placeholderLabel setSingleLineAutoResizeWithMaxWidth:0.1];
    }
    [self.placeholderLabel sizeToFit];
    
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    
    {
        self.nameLabel.attributedText = model.report_name_attributedText;
        [self.nameLabel sizeToFit];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.report_date.doubleValue];
    
    NSString *detail = @"";
    if (model.report_size.length) {
        detail = model.report_size;
    } else if (model.reseacher.length) {
//        detail = model.reseacher;
        if (!model.content_attributedText) {
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            [text appendString:[date stringWithFormat:@"yyyy.MM.dd"]];
            [text appendString:@" "];
            [text appendAttributedString:model.reseacher_attributedText];
            model.content_attributedText = text;
        }
        self.contentLabel.attributedText = model.content_attributedText;
        return;
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@", [date stringWithFormat:@"yyyy.MM.dd"], detail];
    
}

#pragma mark --- Lazy

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        _iconImageView = imageView;
        
        [self.contentView addSubview:imageView];
    }
    return _iconImageView;
}

- (UIImageView *)downImageView {
    if (!_downImageView) {
        UIImageView *imageView = [UIImageView new];
        _downImageView = imageView;
        imageView.image = [UIImage imageNamed:@"icons_down_1"];
        
        [self.contentView addSubview:imageView];
    }
    return _downImageView;
}

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
        
        [self.contentView addSubview:label];
    }
    return _contentLabel;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _placeholderLabel = label;
        
        label.text = @"               ";
        [self.contentView addSubview:label];
    }
    return _placeholderLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.iconImageView.sd_layout
    .widthIs(44*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.nameLabel.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    
    self.placeholderLabel.sd_layout
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.placeholderLabel setMaxNumberOfLinesToShow:1];
    [self.placeholderLabel setSingleLineAutoResizeWithMaxWidth:0.1];
    
    self.contentLabel.sd_resetLayout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.placeholderLabel, 0)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.downImageView.sd_layout
    .widthIs(20*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 2*CA_H_RATIO_WIDTH);
    self.downImageView.hidden = YES;
    
    [CA_HFoundFactoryPattern lineWithView:self left:74*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
