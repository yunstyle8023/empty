//
//  CA_HFoundEnterpriseSearchCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundEnterpriseSearchCell.h"

#import "CA_HFoundSearchModel.h"

@interface CA_HFoundEnterpriseSearchCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation CA_HFoundEnterpriseSearchCell

#pragma mark --- Action

- (void)setModel:(CA_HFoundSearchDataModel *)model {
    [super setModel:model];
    
    {
        self.nameLabel.attributedText = model.enterprise_name_attributedText;
        [self.nameLabel sizeToFit];
    }
    
    {
        NSString *opername = model.opername.length?model.opername:@"暂无";
        if (opername.length>5) {
            opername = [NSString stringWithFormat:@"%@...", [opername substringToIndex:5]];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.setup_date.doubleValue];
        NSString *dataStr = [date stringWithFormat:@"yyyy.MM.dd"];
        NSString *str = [NSString stringWithFormat:@"法人代表：%@ 成立时间：%@", opername, dataStr];
//        str = [str htmlColor:@"999999"];
//
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        attrStr.font = CA_H_FONT_PFSC_Regular(14);
//        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
//
//        self.contentLabel.attributedText = attrStr;
        self.contentLabel.text = str;
        [self.contentLabel sizeToFit];
    }
    
    
    NSString *tag = model.status;
    
    if (tag.length) {
        
        CGFloat width = [tag widthForFont:CA_H_FONT_PFSC_Regular(12)]+10*CA_H_RATIO_WIDTH;
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:330*CA_H_RATIO_WIDTH-width];
        
        self.tagLabel.text = tag;
        self.tagLabel.textColor = [UIColor colorWithHexString:model.status_color];
        
        self.tagLabel.superview.hidden = NO;
    } else {
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:335*CA_H_RATIO_WIDTH];
        self.tagLabel.superview.hidden = YES;
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
    .heightIs(20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 36*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
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
    
    [CA_HFoundFactoryPattern lineWithView:self left:20*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
