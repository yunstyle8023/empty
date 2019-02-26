//
//  CA_HHomeSearchFriendCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchFriendCell.h"

#import "CA_MPersonModel.h"
#import "NSString+CA_HStringCheck.h"

@interface CA_HHomeSearchFriendCell ()

@end

@implementation CA_HHomeSearchFriendCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)upView{
    [super upView];
    
    [self.textLabel setTextColor:CA_H_4BLACKCOLOR];
    [self.textLabel setFont:CA_H_FONT_PFSC_Regular(16)];
    
    [self.detailTextLabel setTextColor:CA_H_9GRAYCOLOR];
    [self.detailTextLabel setFont:CA_H_FONT_PFSC_Regular(14)];
    
    
    self.textLabel.sd_resetLayout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 14*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.detailTextLabel.sd_resetLayout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel, 0)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);

    self.imageView.sd_resetLayout
    .widthIs(50*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    self.imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftEqualToView(self);
}

- (void)setModel:(CA_MPersonModel *)model{
    [super setModel:model];
    
    {
        NSString *str = [NSString stringWithFormat:@"%@", model.chinese_name?:@""];
        str = [str htmlColor:@"444444"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Regular(16);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.textLabel.attributedText = attrStr;
    }
    
    {

        NSMutableString *mutStr = [NSMutableString new];
        for (CA_MPersonTagModel *tagModel in model.tag_data) {
            if (mutStr.length) {
                if (tagModel.tag_name.length) {
                    [mutStr appendString:@" l "];
                }
            }
            [mutStr appendString:tagModel.tag_name];
        }
        if (model.phone.length) {
            if (mutStr.length) {
                [mutStr appendString:@" l "];
            }
            [mutStr appendString:model.phone];
        }
        
        NSString *str = [mutStr htmlColor:@"999999"];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Light(14);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.detailTextLabel.attributedText = attrStr;
    }
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, model.avatar]] placeholder:[UIImage imageNamed:@"head50"]];
}

@end
