//
//  CA_MDiscoverProjectDetailAddView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailAddView.h"

@implementation CA_MDiscoverProjectDetailAddView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = self.bounds;
        [self addSubview:view];
        

        CALayer *subLayer = [CALayer layer];
        CGRect fixframe = self.bounds;
        subLayer.frame = fixframe;
        subLayer.cornerRadius = 21*CA_H_RATIO_WIDTH;
        subLayer.backgroundColor = [UIColor whiteColor].CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
        subLayer.shadowOffset = CGSizeMake(0,0);
        subLayer.shadowOpacity = 0.5;
        subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;
        [view.layer insertSublayer:subLayer below:view.layer];
        
        UIButton *includeBtn = [UIButton new];
        includeBtn.layer.cornerRadius = 21*CA_H_RATIO_WIDTH;
        includeBtn.layer.masksToBounds = YES;
        includeBtn.frame = self.bounds;
        [includeBtn configTitle:@"一键收录" titleColor:CA_H_TINTCOLOR font:16];
        includeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:includeBtn];
        [includeBtn addTarget:self action:@selector(includeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)includeBtnAction{
    if (_pushBlock) {
        _pushBlock();
    }
}

@end
