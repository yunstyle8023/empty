//
//  CA_MDiscoverTitleView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverTitleView.h"

@implementation CA_MDiscoverTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CA_HSetButton *searchButton = [CA_HSetButton new];
        
        searchButton.backgroundColor = CA_H_F8COLOR;
        [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
        searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(onSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:searchButton];
        searchButton.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
    }
    return self;
}

-(void)onSearchButton:(UIButton *)sender{
    if (self.jumpBlock) {
        self.jumpBlock();
    }
}

@end
