//
//  CA_HScreeningTagCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HScreeningTagCell.h"

@interface CA_HScreeningTagCell ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation CA_HScreeningTagCell

#pragma mark --- Lazy

- (UILabel *)textLabel{
    if (!_textLabel) {
        UILabel * label = [UILabel new];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = CA_H_FONT_PFSC_Regular(14);
        
        _textLabel = label;
    }
    return _textLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView * imageView = [UIImageView new];
        
        imageView.image = [UIImage imageNamed:@"choose2_icon"];
        
        _imageView = imageView;
    }
    return _imageView;
}

- (UIView *)backView{
    if (!_backView) {
        UIView * view = [UIView new];
        
        [view addSubview:self.imageView];
        self.imageView.sd_layout
        .widthIs(18*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .rightEqualToView(view)
        .bottomEqualToView(view);
        
        [view addSubview:self.textLabel];
        self.textLabel.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        _backView = view;
    }
    return _backView;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.imageView.hidden = !selected;
    if (selected) {
        self.backView.backgroundColor = CA_H_TINTCOLOR;
        self.textLabel.textColor = [UIColor whiteColor];
    }else{
        self.backView.backgroundColor = CA_H_F8COLOR;
        self.textLabel.textColor = CA_H_6GRAYCOLOR;
    }
}

#pragma mark --- LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView{
    self.selected = NO;
    
    [self.contentView addSubview:self.backView];
    self.backView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.backView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
}

@end
