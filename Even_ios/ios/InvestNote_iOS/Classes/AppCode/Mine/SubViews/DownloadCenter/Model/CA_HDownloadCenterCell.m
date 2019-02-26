//
//  CA_HDownloadCenterCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadCenterCell.h"

#import "NSString+CA_HStringCheck.h"

@interface CA_HDownloadCenterCell ()

@property (nonatomic, strong) UIButton * editButton;
@property (nonatomic, strong) UIImageView *downImageView;

@end

@implementation CA_HDownloadCenterCell

#pragma mark --- Action

- (void)onEdit:(UIButton *)sender {
    if (_editBlock) {
        _editBlock(self);
    }
}

#pragma mark --- Lazy

- (UIImageView *)downImageView {
    if (!_downImageView) {
        UIImageView *imageView = [UIImageView new];
        _downImageView = imageView;
        imageView.image = [UIImage imageNamed:@"icons_down_1"];
        
        [self.contentView addSubview:imageView];
    }
    return _downImageView;
}

- (UIButton *)editButton{
    if (!_editButton) {
        UIButton * button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        
        button.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        
        _editButton = button;
    }
    
    return _editButton;
}

- (void)setModel:(NSDictionary *)model {
    [super setModel:model];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:model[@"fileIcon"]] placeholder:[UIImage imageNamed:@"icons_file_？"]];
//    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CA_H_SERVER_API, model[@"fileIcon"]]] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    
    self.textLabel.text = model[@"fileName"];
    self.detailTextLabel.text = model[@"showDetail"];
}
#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView{
    [super upView];
    
    self.imageView.sd_resetLayout
    .widthIs(44*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.numberOfLines = 1;
    
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 74*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:250*CA_H_RATIO_WIDTH];
    
    
    self.downImageView.sd_layout
    .widthIs(20*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH);
    
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    self.detailTextLabel.numberOfLines = 1;
    
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 97*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:227*CA_H_RATIO_WIDTH];
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftSpaceToView(self, 74*CA_H_RATIO_WIDTH);
    
    [self editButton];
}

- (void)setColorStr:(NSString *)colorStr {
    if (colorStr.length) {
        if ([self.textLabel.text containsString:colorStr]) {
            self.textLabel.attributedText = [self.textLabel.text colorText:colorStr font:self.textLabel.font color:CA_H_4BLACKCOLOR changeColor:CA_H_TINTCOLOR];
        } else {
            self.textLabel.textColor = CA_H_4BLACKCOLOR;
        }
        if ([self.detailTextLabel.text containsString:colorStr]) {
            self.detailTextLabel.attributedText = [self.detailTextLabel.text colorText:colorStr font:self.detailTextLabel.font color:CA_H_9GRAYCOLOR changeColor:CA_H_TINTCOLOR];
        } else {
            self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
        }
    }
}


#pragma mark --- Delegate

@end
