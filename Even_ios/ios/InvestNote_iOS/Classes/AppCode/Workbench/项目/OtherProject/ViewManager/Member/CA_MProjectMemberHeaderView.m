
//
//  CA_MProjectMemberHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectMemberHeaderView.h"

@implementation CA_MProjectMemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = kColor(@"#FFFFFF");
    
    UILabel* titleLb = [[UILabel alloc] init];
    [titleLb configText:@"项目成员" textColor:CA_H_4BLACKCOLOR font:18];
    titleLb.font = CA_H_FONT_PFSC_Medium(18);
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        if (kDevice_Is_iPhoneX) {
            make.bottom.mas_equalTo(self).offset(-10);
        }else{
            make.bottom.mas_equalTo(self).offset(-15);
        }
        
    }];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-1);
        make.height.mas_equalTo(1);
    }];
}
@end
