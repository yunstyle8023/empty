
//
//  CA_MDiscoverSponsorChangeView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorChangeView.h"

@implementation CA_MDiscoverSponsorChangeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = self.bounds;
        [self addSubview:view];
        
        
        CALayer *subLayer = [CALayer layer];
        CGRect fixframe = self.bounds;
        subLayer.frame = fixframe;
        subLayer.cornerRadius = 17*CA_H_RATIO_WIDTH;
        subLayer.backgroundColor = kColor(@"#F8F8F8").CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
        subLayer.shadowOffset = CGSizeMake(0,0);
        subLayer.shadowOpacity = 0.5;
        subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;
        [view.layer insertSublayer:subLayer below:view.layer];
        
        UIButton *includeBtn = [UIButton new];
        includeBtn.layer.cornerRadius = 17*CA_H_RATIO_WIDTH;
        includeBtn.layer.masksToBounds = YES;
        includeBtn.frame = self.bounds;
        [includeBtn configTitle:@"换一批" titleColor:CA_H_TINTCOLOR font:16];
        [includeBtn setImage:kImage(@"changeSponsor") forState:UIControlStateNormal];
        includeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        includeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [view addSubview:includeBtn];
        [includeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)changeBtnAction{
    if (_pushBlock) {
        _pushBlock();
    }
}

@end
