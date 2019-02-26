//
//  CA_HCustomAlert.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HCustomAlert.h"

#define CA_HCustomAlert_tag 201805181040

@interface CA_HCustomAlert ()

@property (nonatomic, strong) UIView *alertView;

@end

@implementation CA_HCustomAlert

+ (CA_HCustomAlert *)alertView:(UIView *)view {
    return [self alertView:view superView:CA_H_MANAGER.mainWindow];
}
+ (void)hide:(BOOL)animated {
    [self hide:animated superView:CA_H_MANAGER.mainWindow];
}

+ (CA_HCustomAlert *)alertView:(UIView *)view superView:(UIView *)superView {
    CA_HCustomAlert *alert = [self new];
    
    [alert.alertView addSubview:view];
    view.sd_layout
    .centerXEqualToView(alert.alertView)
    .centerYEqualToView(alert.alertView);
    [alert.alertView setupAutoWidthWithRightView:view rightMargin:0];
    [alert.alertView setupAutoHeightWithBottomView:view bottomMargin:0];
    
    [superView addSubview:alert];
    alert.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    return alert;
}
+ (void)hide:(BOOL)animated superView:(UIView *)superView {
    
    CA_HCustomAlert *alert = [superView viewWithTag:CA_HCustomAlert_tag];
    
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        alert.alpha = 0;
    } completion:^(BOOL finished) {
        [alert removeFromSuperviewAndClearAutoLayoutSettings];
    }];
}

#pragma mark --- Action

#pragma mark --- Lazy

- (UIView *)alertView {
    if (!_alertView) {
        UIView *view = [UIView new];
        _alertView = view;
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10*CA_H_RATIO_WIDTH;
        view.layer.masksToBounds = YES;
        
        [self addSubview:view];
    }
    return _alertView;
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
    self.tag = CA_HCustomAlert_tag;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.alpha = 0.35;
    [self addSubview:toolbar];
    [self sendSubviewToBack:toolbar];
    toolbar.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.alertView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .offset(-40*CA_H_RATIO_HEIGHT);
}

#pragma mark --- Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.alertView];
        if (![self.alertView pointInside:point withEvent:event]) {
            [CA_HCustomAlert hide:YES superView:self.superview];
            return;
        }
    }
}

@end
