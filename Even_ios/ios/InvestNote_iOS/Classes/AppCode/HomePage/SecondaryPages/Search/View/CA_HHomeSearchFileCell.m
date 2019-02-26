//
//  CA_HHomeSearchFileCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchFileCell.h"

#import "CA_HBrowseFoldersModel.h"
#import "NSString+CA_HStringCheck.h"
#import "CA_HFileIconManager.h"

@implementation CA_HHomeSearchFileCell

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
    self.textLabel.numberOfLines = 1;
    
    [self.detailTextLabel setTextColor:CA_H_9GRAYCOLOR];
    [self.detailTextLabel setFont:CA_H_FONT_PFSC_Regular(14)];
    self.detailTextLabel.numberOfLines = 1;
    
    
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
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftEqualToView(self);
}

- (void)setModel:(CA_HBrowseFoldersModel *)model{
    [super setModel:model];
    
    if ([model.file_type isEqualToString:@"directory"]) {
        if (model.creator.user_id.integerValue) {
            self.detailTextLabel.text = model.creator.chinese_name;
        } else {
            self.detailTextLabel.text = CA_H_LAN(@"默认文件夹");
        }
        self.imageView.image = [UIImage imageNamed:@"file_icon"];
    } else {
        
        self.detailTextLabel.text = model.showDetail;
        
        if (model.file_icon.length) {
            [self.imageView setImageWithURL:[NSURL URLWithString:model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
        } else {
            self.imageView.image = [CA_HFileIconManager iconWithFileName:model.file_name];
        }
    }
    
    {
        NSString *str = [NSString stringWithFormat:@"%@", model.file_name?:@""];
        str = [str htmlColor:@"444444"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Regular(16);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.textLabel.attributedText = attrStr;
    }
}

@end
