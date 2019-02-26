//
//  CA_HUserScreeningCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2019/1/8.
//  Copyright © 2019年 韩云智. All rights reserved.
//

#import "CA_HUserScreeningCell.h"
#import "CA_HParticipantsModel.h"

@interface CA_HUserScreeningCell ()

@property (nonatomic, strong) UIImageView *chooseIcon;

@end

@implementation CA_HUserScreeningCell

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setModel:(CA_HParticipantsModel *)model {
    [super setModel:model];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, model.avatar]] placeholder:[UIImage imageNamed:@"head30"]];
    self.textLabel.text = model.chinese_name?:@"";
}

- (UIImageView *)chooseIcon {
    if (!_chooseIcon) {
        UIImageView *imageView = [UIImageView new];
        _chooseIcon = imageView;
        
        imageView.image = [UIImage imageNamed:@"多选_未选中"];
        [self.contentView addSubview:imageView];
        imageView.sd_layout
        .widthIs(16*CA_H_RATIO_WIDTH)
        .heightIs(16*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _chooseIcon;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.chooseIcon.image = [UIImage imageNamed:selected?@"多选_选中":@"多选_未选中"];
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.imageView.sd_resetLayout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    self.imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.numberOfLines = 1;
    self.textLabel.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake(0, 60*CA_H_RATIO_WIDTH, 0, 60*CA_H_RATIO_WIDTH));
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftEqualToView(self.contentView);
}

#pragma mark --- Delegate

@end
