//
//  CA_HPeopleCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HPeopleCell.h"
#import "CA_HParticipantsModel.h"

@interface CA_HPeopleCell ()

@property (nonatomic, strong) UIView *headerView;

@end

@implementation CA_HPeopleCell

#pragma mark --- Action

- (void)setModel:(NSArray<CA_HParticipantsModel *> *)model {
    [super setModel:model];
    
    NSInteger imageCount = model.count;
    
    UIImageView *imageView;
    for (NSInteger i=0; i<imageCount; i++) {
        imageView = [self customImageView:i];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CA_H_SERVER_API, model[i].avatar]] placeholder:[UIImage imageNamed:@"head20"]];
    }
    
    if (imageCount > 0) {
        self.headerView.height = (35*ceilf(imageCount/8.0)-5)*CA_H_RATIO_WIDTH;
        self.textLabel.hidden = YES;
        [self setupAutoHeightWithBottomView:self.headerView bottomMargin:12*CA_H_RATIO_WIDTH];
    } else {
        self.textLabel.hidden = NO;
        [self setupAutoHeightWithBottomView:self.imageView bottomMargin:15*CA_H_RATIO_WIDTH];
    }
    
}

#pragma mark --- Lazy

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [UIView new];
        _headerView = view;
        
        view.frame = CGRectMake(54*CA_H_RATIO_WIDTH, 12*CA_H_RATIO_WIDTH, 275*CA_H_RATIO_WIDTH, 0);
        [self.contentView addSubview:view];
    }
    return _headerView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.imageView.sd_resetLayout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.imageView.superview, 15*CA_H_RATIO_WIDTH);
    self.imageView.image = [UIImage imageNamed:@"project_icon3"];
    
    
    self.textLabel.text = CA_H_LAN(@"未添加参与人");
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.sd_resetLayout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(300*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.imageView, 10*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView);
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

- (UIImageView *)customImageView:(NSInteger)tag {
    UIImageView *imageView = [self.headerView viewWithTag:200+tag];
    
    if (!imageView) {
        
        imageView = [UIImageView new];
        imageView.tag = 200+tag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 15*CA_H_RATIO_WIDTH;
        imageView.clipsToBounds = YES;
        
        imageView.frame = CGRectMake(tag%8*35*CA_H_RATIO_WIDTH, tag/8*35*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
        
        [self.headerView addSubview:imageView];
    }
    
    return imageView;
}

#pragma mark --- Delegate

@end
