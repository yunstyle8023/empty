//
//  CA_HParticipantsCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HParticipantsCell.h"
#import "CA_HParticipantsModel.h"

@interface CA_HParticipantsCell ()

@property (nonatomic, strong) UIImageView *chooseIcon;

@property (nonatomic, strong) UILabel *allLabel;

@end

@implementation CA_HParticipantsCell


#pragma mark --- Action

#pragma mark --- Lazy

- (void)setModel:(CA_HParticipantsModel *)model {
    [super setModel:model];
    
    if ([model isKindOfClass:[CA_HParticipantsModel class]]) {
        
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, model.avatar]] placeholder:[UIImage imageNamed:@"head50"]];
        self.textLabel.text = model.chinese_name;
    } else {
        [self allLabel];
        self.textLabel.text = CA_H_LAN(@"选中所有人");
    }
}

- (UIImageView *)chooseIcon {
    if (!_chooseIcon) {
        UIImageView *imageView = [UIImageView new];
        _chooseIcon = imageView;

        imageView.image = [UIImage imageNamed:@"choose"];
        [self.contentView addSubview:imageView];
        imageView.sd_layout
        .widthIs(20*CA_H_RATIO_WIDTH)
        .heightIs(15*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _chooseIcon;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.chooseIcon.hidden = !selected;
}

- (UILabel *)allLabel {
    if (!_allLabel) {
        UILabel *label = [UILabel new];
        _allLabel = label;
        
        label.font = CA_H_FONT_PFSC_Regular(20);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"A";
        label.backgroundColor = CA_H_TINTCOLOR;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .widthIs(50*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView);
        label.sd_cornerRadiusFromWidthRatio = @(0.5);
    }
    return _allLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.imageView.sd_resetLayout
    .widthIs(50*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    self.imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.numberOfLines = 1;
    self.textLabel.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake(0, 80*CA_H_RATIO_WIDTH, 0, 60*CA_H_RATIO_WIDTH));
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
