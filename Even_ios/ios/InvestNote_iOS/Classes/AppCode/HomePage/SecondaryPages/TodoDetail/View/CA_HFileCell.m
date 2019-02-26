//
//  CA_HFileCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFileCell.h"
#import "CA_HTodoDetailModel.h"

@implementation CA_HFileCell

#pragma mark --- Action

- (void)setModel:(CA_HTodoDetailFileModel *)model {
    [super setModel:model];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    self.textLabel.text = model.file_name;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_update.doubleValue];
    NSString *dateStr = [date stringWithFormat:@"yyyy.MM.dd"];
    
    double size = model.file_size.doubleValue;
    
    NSString * fileSize;
    if (size < 102.4) {
        fileSize = [NSString stringWithFormat:@"%.1fB", size];
    }else if (size < 102.4*1024) {
        fileSize = [NSString stringWithFormat:@"%.1fK", size/1024.0];
    } else {
        fileSize = [NSString stringWithFormat:@"%.1fM", size/(1024.0*1024.0)];
    }
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@", dateStr, fileSize];
    
}

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    
    
    self.textLabel.font = CA_H_FONT_PFSC_Medium(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.numberOfLines = 1;
    
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    self.detailTextLabel.numberOfLines = 1;
    
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:275*CA_H_RATIO_WIDTH];
    
    self.imageView.sd_resetLayout
    .widthIs(50*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
