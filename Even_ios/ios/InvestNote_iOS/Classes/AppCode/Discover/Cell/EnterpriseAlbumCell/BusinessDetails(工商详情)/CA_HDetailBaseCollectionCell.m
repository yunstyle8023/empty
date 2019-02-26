//
//  CA_HDetailBaseCollectionCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDetailBaseCollectionCell.h"


@implementation CA_HDetailBaseCollectionCell

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
    self.backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
