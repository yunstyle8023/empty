//
//  CA_HNoteFileView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteFileView.h"

@interface CA_HNoteFileView ()

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) CALayer *subLayer;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CA_HNoteFileView

#pragma mark --- Action

#pragma mark --- Lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView;
        
        imageView.image = [UIImage imageNamed:self.imageName];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        _label = label;
        
        label.textColor = CA_H_4BLACKCOLOR;
        label.numberOfLines = 1;
    }
    return _label;
}

- (CALayer *)subLayer {
    if (!_subLayer) {
        
        CALayer *subLayer=[CALayer layer];
        _subLayer = subLayer;
        
        UIColor *shadowColor = CA_H_SHADOWCOLOR;
        
        subLayer.cornerRadius = 5*CA_H_RATIO_WIDTH;
        subLayer.backgroundColor=[UIColor whiteColor].CGColor;//shadowColor.CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
        subLayer.shadowRadius = 4*CA_H_RATIO_WIDTH;//阴影半径，默认3
        
    }
    return _subLayer;
}

#pragma mark --- LifeCircle

+ (instancetype)newWith:(NSString *)type {
    CA_HNoteFileView *view = [self new];
    if ([type isEqualToString:@"record"]) {
        view.imageName = @"micro_icon";
        view.label.font = CA_H_FONT_PFSC_Light(16);
    } else {
        view.imageName = @"attachment_icon";
        view.label.font = CA_H_FONT_PFSC_Regular(16);
    }
    [view upView];
    return view;
}

#pragma mark --- Custom

- (void)upView {
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 98*CA_H_RATIO_WIDTH);
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    CA_H_WeakSelf(self);
    view.didFinishAutoLayoutBlock = ^(CGRect frame) {
        CA_H_StrongSelf(self);
        self.subLayer.frame= frame;
    };
    [self addSubview:view];
    view.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    view.sd_cornerRadius = @(5*CA_H_RATIO_WIDTH);
    
    [self.layer insertSublayer:self.subLayer below:view.layer];
    
    [view addSubview:self.imageView];
    self.imageView.sd_layout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(view)
    .leftSpaceToView(view, 13*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.label];
    self.label.sd_layout
    .leftSpaceToView(view, 50*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .topEqualToView(view)
    .bottomEqualToView(view);
//    [self.label setMaxNumberOfLinesToShow:1];
}

- (void)setDuration:(NSNumber *)duration {
    self.label.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", duration.longValue/3600, duration.longValue%3600/60, duration.longValue%60];
}

- (void)setFileName:(NSString *)fileName {
    self.label.text = fileName;
}

#pragma mark --- Delegate

@end
