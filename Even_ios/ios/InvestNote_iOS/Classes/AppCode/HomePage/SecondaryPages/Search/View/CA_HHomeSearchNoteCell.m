//
//  CA_HHomeSearchNoteCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchNoteCell.h"

#import "CA_HListNoteModel.h"
#import "NSString+CA_HStringCheck.h"

@interface CA_HHomeSearchNoteCell ()

@property (nonatomic, strong) UILabel * tagLabel;

@end

@implementation CA_HHomeSearchNoteCell

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
    
    _tagLabel = [UILabel new];
    _tagLabel.textColor = CA_H_9GRAYCOLOR;
    _tagLabel.font = CA_H_FONT_PFSC_Light(12);
    
    [self.contentView addSubview:_tagLabel];
    
    [self.textLabel setTextColor:CA_H_4BLACKCOLOR];
    [self.textLabel setFont:CA_H_FONT_PFSC_Medium(16)];
    
    [self.detailTextLabel setTextColor:CA_H_9GRAYCOLOR];
    [self.detailTextLabel setFont:CA_H_FONT_PFSC_Light(13)];
    
    
    self.textLabel.sd_resetLayout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.detailTextLabel.sd_resetLayout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel, 5*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    _tagLabel.sd_layout
    .heightIs(17*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftEqualToView(self);
}

- (void)setModel:(CA_HListNoteContentModel *)model{
    [super setModel:model];
    
    {
        NSString *str = [NSString stringWithFormat:@"%@", model.note_title?:@""];
        str = [str htmlColor:@"444444"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Medium(16);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.textLabel.attributedText = attrStr;
    }

    {
        NSString *str = [NSString stringWithFormat:@"%@", model.content?:@""];
        str = [str htmlColor:@"999999"];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        attrStr.font = CA_H_FONT_PFSC_Light(13);
        attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.detailTextLabel.attributedText = attrStr;
    }
    
    
    {
        NSString *tagStr = nil;
        if (model.object_id.integerValue
            &&
            model.note_type_id.integerValue) {
            tagStr = [NSString stringWithFormat:@"%@·%@", model.object_name, model.note_type_name];
        } else {
            tagStr = [NSString stringWithFormat:@"%@%@", model.object_name, model.note_type_name];
        }
        _tagLabel.text = tagStr.length?tagStr:CA_H_LAN(@"未设置");
    }
}

@end
