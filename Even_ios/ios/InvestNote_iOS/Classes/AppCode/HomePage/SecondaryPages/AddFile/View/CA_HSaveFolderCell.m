//
//  CA_HSaveFolderCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/25.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSaveFolderCell.h"

#import "CA_HBrowseFoldersModel.h"

@interface CA_HSaveFolderCell ()

@end

@implementation CA_HSaveFolderCell
#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self upView];
    }
    return self;
}



#pragma mark --- Custom

- (void)upView{
    [super upView];
    
    _chooseIcon = [UIImageView new];
    _chooseIcon.image = [UIImage imageNamed:@"choose"];
    _chooseIcon.hidden = YES;
    [self.contentView addSubview:_chooseIcon];
    _chooseIcon.sd_layout
    .widthIs(20*CA_H_RATIO_WIDTH)
    .heightIs(15*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.imageView.sd_resetLayout
    .widthIs(44*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 74*CA_H_RATIO_WIDTH);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:280*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 74*CA_H_RATIO_WIDTH);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:241*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH);
    
}

- (void)setModel:(CA_HBrowseFoldersModel *)model{
    [super setModel:model];
    
    self.imageView.image = [UIImage imageNamed:@"file_icon"];
    
    self.textLabel.text = model.file_name;
    [self.textLabel sizeToFit];
    
    NSArray *array = model.file_path;
    
    if ([array.firstObject isEqualToString:@"/"]) {
        NSMutableArray *mut = [NSMutableArray arrayWithArray:array];
        [mut removeFirstObject];
        array = mut;
    }
    
    NSString *str = [array componentsJoinedByString:@">"];
    NSInteger i = 0;
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:array];
    while ([str widthForFont:CA_H_FONT_PFSC_Regular(14)]>241*CA_H_RATIO_WIDTH
           &&
           i<array.count-1) {
        NSString *text = mutArray[i];
        if (text.length>1) {
            text = [NSString stringWithFormat:@"%@...", [text substringToIndex:1]];
        }
        [mutArray replaceObjectAtIndex:i withObject:text];
        str = [mutArray componentsJoinedByString:@">"];
        
        i++;
    }
    
    self.detailTextLabel.text = str;
}

@end
