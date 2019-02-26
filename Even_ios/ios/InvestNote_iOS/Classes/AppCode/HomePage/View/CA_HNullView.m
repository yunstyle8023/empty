//
//  CA_HNullView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HNullView.h"

@interface CA_HNullView ()

@property (nonatomic, copy) void (^block)(void);

@end

@implementation CA_HNullView

+ (instancetype)newTitle:(NSString *)title
             buttonTitle:(NSString *)buttonTitle
                     top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName {
    CA_HNullView *view = [self new];
    view.block = block;
    [view viewTitle:title buttonTitle:buttonTitle top:top imageName:imageName];
    
    CA_HNullView *backView = [self new];
    [backView addSubview:view];
    view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    return backView;
}

- (void)viewTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle top:(CGFloat)top imageName:(NSString *)imageName {
    
    UIImageView *imageView = [UIImageView new];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    [self addSubview:imageView];
    imageView.sd_layout
    .widthIs(185*CA_H_RATIO_WIDTH)
    .heightIs(162*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self)
    .topSpaceToView(self, top);
    
    
    CA_HSetLabel *label = [CA_HSetLabel new];
    label.textColor = CA_H_TINTCOLOR;
    label.font = CA_H_FONT_PFSC_Regular(18);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = title;
    
    [self addSubview:label];
    label.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(imageView, (imageName?39:-90)*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [label setMaxNumberOfLinesToShow:0];
    [label setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-40*CA_H_RATIO_WIDTH];
    
    
    if (buttonTitle) {
        CA_HSetButton * button = [CA_HSetButton new];
        [button setBackgroundColor:CA_H_TINTCOLOR];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(18);
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        button.sd_layout
        .widthIs(146*CA_H_RATIO_WIDTH)
        .heightIs(48*CA_H_RATIO_WIDTH)
        .centerXEqualToView(self)
        .topSpaceToView(label, 30*CA_H_RATIO_WIDTH);
        
        button.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
        
    }
}

- (void)onButton:(UIButton *)sender{
    if (_block) {
        _block();
    }
}

@end
