//
//  CA_HHomeSearchProjectCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchProjectCell.h"

#import "CA_HMoveListModel.h"
#import "NSString+CA_HStringCheck.h"

@interface CA_HHomeSearchProjectCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView * chooseIcon;

@end

@implementation CA_HHomeSearchProjectCell

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        _label = label;
        
        label.textColor = [UIColor whiteColor];
        label.font = CA_H_FONT_PFSC_Regular(20);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .widthIs(45*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        label.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    }
    return _label;
}

- (UIImageView *)chooseIcon {
    if (!_chooseIcon) {
        UIImageView *imageView = [UIImageView new];
        _chooseIcon = imageView;
        imageView.image = [UIImage imageNamed:@"choose"];
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
        imageView.sd_layout
        .widthIs(20*CA_H_RATIO_WIDTH)
        .heightIs(15*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _chooseIcon;
}

- (void)upView{
    [super upView];
    
    [self.textLabel setTextColor:CA_H_4BLACKCOLOR];
    [self.textLabel setFont:CA_H_FONT_PFSC_Regular(16)];
    
    self.textLabel.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    self.imageView.sd_resetLayout
    .widthIs(45*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    self.imageView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftEqualToView(self);
}

- (void)setModel:(CA_MProjectModel *)model{
    [super setModel:model];
    
    if (![model isKindOfClass:[CA_MProjectModel class]]) {
        return;
    }
    
    {
        NSString *str = [NSString stringWithFormat:@"%@", model.project_name?:@""];
        str = [str htmlColor:@"444444"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Regular(16);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.textLabel.attributedText = attrStr;
    }
    
    if (model.project_logo.length) {
        _label.hidden = YES;
        
        NSString *urlStr = model.project_logo;
        urlStr = ^{
            if ([urlStr hasPrefix:@"http://"]
                ||
                [urlStr hasPrefix:@"https://"]) {
                return urlStr;
            }
            return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
        }();
        [self.imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"loadfail_project50"]];
    } else {
        _label.hidden = NO;
        self.imageView.image = nil;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[model.project_name dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSString *name = attrStr.string;
        if (name.length) {
            self.label.text = [name substringToIndex:1];
        } else {
            self.label.text = @"";
        }
        self.label.backgroundColor = [UIColor colorWithHexString:model.project_color];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (_isChoose) {
        self.chooseIcon.hidden = !selected;
    }
}

@end
