//
//  CA_HMultiSelectCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMultiSelectCell.h"

@interface CA_HMultiSelectCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CALayer *subLayer;
@property (nonatomic, strong) UIToolbar *toolbar;


@end

@implementation CA_HMultiSelectCell

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    if (_selectedBlock) {
        self.number = _selectedBlock(!sender.selected);
    }
}

#pragma mark --- Lazy

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView * imageView = [UIImageView new];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:imageView];
        [self.contentView sendSubviewToBack:imageView];
        
        imageView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        _imageView = imageView;
    }
    return _imageView;
}

- (CALayer *)subLayer {
    if (!_subLayer) {
        CALayer *subLayer=[CALayer layer];
        _subLayer = subLayer;
        
        UIColor *shadowColor = [UIColor blackColor];
        
        subLayer.cornerRadius = 2*CA_H_RATIO_WIDTH;
        
        UIImage *image = [[UIImage imageNamed:@"pic_choose_small_icon"] imageByResizeToSize:CGSizeMake(18*CA_H_RATIO_WIDTH, 18*CA_H_RATIO_WIDTH)];
        subLayer.backgroundColor= [UIColor colorWithPatternImage:image].CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
        subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
        
        [self.contentView.layer insertSublayer:subLayer below:self.button.layer];
    }
    return _subLayer;
}

- (UIButton *)button{
    if (!_button) {
        UIButton *button = [UIButton new];
        _button = button;
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:CA_H_FONT_PFSC_Semibold(12)];
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        
        CA_H_WeakSelf(self);
        button.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            self.subLayer.frame= frame;
        };
        
        button.sd_layout
        .widthIs(18*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(self.contentView, 5*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 5*CA_H_RATIO_WIDTH);
        
//        button.sd_cornerRadius = @(2*CA_H_RATIO_WIDTH);
        button.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
        button.layer.masksToBounds = YES;
        
    }
    return _button;
}

- (UIToolbar *)toolbar{
    if (!_toolbar) {
        UIToolbar * toolbar = [UIToolbar new];
        
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.alpha = 0.5;
        
        [self.contentView addSubview:toolbar];
        [self.contentView insertSubview:toolbar belowSubview:self.button];
        
        toolbar.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        _toolbar = toolbar;
    }
    return _toolbar;
}

- (void)setNumber:(NSUInteger)number{
    _number = number;
    
    if (number > 0) {
        [self.button setTitle:[NSString stringWithFormat:@"%ld", number] forState:UIControlStateNormal];
        self.button.selected = YES;
        self.toolbar.hidden = NO;
    }else{
        [self.button setTitle:@"" forState:UIControlStateNormal];
        self.button.selected = NO;
        self.toolbar.hidden = YES;
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
    [self button];
}


@end
