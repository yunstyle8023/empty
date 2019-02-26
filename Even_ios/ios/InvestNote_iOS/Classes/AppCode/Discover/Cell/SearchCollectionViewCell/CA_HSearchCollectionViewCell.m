//
//  CA_HSearchCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSearchCollectionViewCell.h"

@interface CA_HSearchCollectionViewCell ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation CA_HSearchCollectionViewCell

#pragma mark --- Action

#pragma mark --- Lazy

- (UIView *)backView {
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
        
        view.backgroundColor = CA_H_F8COLOR;
    }
    return _backView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_6GRAYCOLOR];
        _label = label;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _label;
}

#pragma mark --- LifeCircle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    [self.contentView addSubview:self.backView];
    self.backView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.backView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    [self.backView addSubview:self.label];
    self.label.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Delegate

@end
