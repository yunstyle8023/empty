//
//  CA_HFileListCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HFileListCell.h"
#import "CA_HBrowseFoldersModel.h"

@interface CA_HFileListCell ()

@property (nonatomic, strong) UIButton * editButton;

@end

@implementation CA_HFileListCell

#pragma mark --- Action

- (void)onEdit:(UIButton *)sender{
    _editBlock(self);
}

#pragma mark --- Lazy

- (void)setModel:(CA_HBrowseFoldersModel *)model {
    [super setModel:model];
    self.textLabel.text = model.file_name;
    [self.textLabel sizeToFit];
    
    BOOL set = ([model.path_option indexOfObject:@"handle"]!=NSNotFound);
    self.editButton.hidden = !_editBlock||!set;
}

- (UIButton *)editButton{
    if (!_editButton) {
        UIButton * button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        
        button.sd_layout
        .widthIs(64*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topEqualToView(self.contentView)
        .rightEqualToView(self.contentView);
        
        button.imageView.sd_resetLayout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(button, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(button, 20*CA_H_RATIO_WIDTH);
        
        _editButton = button;
    }
    
    return _editButton;
}

- (void)setEditBlock:(void (^)(UITableViewCell * editCell))editBlock{
    _editBlock = editBlock;
    if (editBlock
        &&
        ![self.reuseIdentifier isEqualToString:@"default"]) {
        [self editButton];
    }
}

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
    
    self.imageView.image = [UIImage imageNamed:@"file_icon"];
    
    self.imageView.sd_resetLayout
    .widthIs(44*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    
    if ([self.reuseIdentifier isEqualToString:@"default"]) {
        self.textLabel.sd_resetLayout
        .topSpaceToView(self.textLabel.superview, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.textLabel.superview, 74*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        
        self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
        self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
        self.detailTextLabel.text = CA_H_LAN(@"默认文件夹");
        
        self.detailTextLabel.sd_resetLayout
        .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.detailTextLabel.superview, 74*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [self.detailTextLabel setMaxNumberOfLinesToShow:1];
        [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH];
    }else {
        self.textLabel.sd_resetLayout
        .centerYEqualToView(self.textLabel.superview)
        .leftSpaceToView(self.textLabel.superview, 74*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        
    }
    
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH);
}

@end
