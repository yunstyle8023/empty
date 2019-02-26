
//
//  CA_MNewProjectSearchView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectSearchView.h"

@interface CA_MNewProjectSearchView ()
@property(nonatomic,strong)UIButton* searchBtn;
@end

@implementation CA_MNewProjectSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBtn];
        self.searchBtn.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .centerYEqualToView(self)
        .heightIs(30*CA_H_RATIO_WIDTH);
    }
    return self;
}

-(void)searchBtnAction:(UIButton *)sender{
    if (self.jumpBlock) self.jumpBlock();
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton new];
        [_searchBtn configTitle:@" 搜索"
                     titleColor:CA_H_9GRAYCOLOR
                           font:14];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
        _searchBtn.layer.cornerRadius = 6;
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.backgroundColor = kColor(@"#F8F8F8");
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

@end
