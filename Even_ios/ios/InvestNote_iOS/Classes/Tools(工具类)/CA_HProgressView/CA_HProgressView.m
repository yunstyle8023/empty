//
//  CA_HProgressView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HProgressView.h"

@interface CA_HProgressView ()

@end

@implementation CA_HProgressView

#pragma mark --- Action

- (void)setProgress:(float)progress {
    _progress = progress;
    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD(^{
        CA_H_StrongSelf(self);
        if (progress < 1) {
            [self.slider setValue:progress animated:YES];
        } else {
            [self.slider setValue:1 animated:YES];
            for (UIImageView *imageView in self.slider.subviews) {
                if (imageView.frame.size.width>0) {
                    imageView.layer.cornerRadius = imageView.frame.size.height/2;
                    imageView.layer.masksToBounds = YES;
                }
            }
        }
    });
}

#pragma mark --- Lazy

- (UISlider *)slider {
    if (!_slider) {
        UISlider *slider = [UISlider new];
        _slider = slider;
        
        [slider setThumbImage:[UIImage new] forState:UIControlStateNormal];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.maximumTrackTintColor = CA_H_BACKCOLOR;
        slider.minimumTrackTintColor = CA_H_TINTCOLOR;
    }
    return _slider;
}

#pragma mark --- LifeCircle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    [self addSubview:self.slider];
    self.slider.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
//    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Delegate

@end
