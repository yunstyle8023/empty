
//
//  CA_MPersonDetailInfoHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailInfoHeaderView.h"

@implementation CA_MPersonDetailInfoHeaderView

-(instancetype)initWithTitle:(NSString*)title
                      hidden:(BOOL)hidden
                     message:(NSString*)message{
    if (self = [super init]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        UILabel* titleLb = [UILabel new];
        [titleLb configText:title textColor:CA_H_4BLACKCOLOR font:18];
        [self addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(20);
            make.centerY.mas_equalTo(self);
        }];
        UIView* lineView = [UIView new];
        lineView.backgroundColor = CA_H_BACKCOLOR;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(20);
            make.trailing.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(CA_H_LINE_Thickness);
        }];
        lineView.hidden = hidden;
        
        if ([NSString isValueableString:message]) {
            UILabel* strLb = [UILabel new];
            [strLb configText:message textColor:CA_H_9GRAYCOLOR font:12];
            [self addSubview:strLb];
            [strLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(self).offset(-20);
                make.bottom.mas_equalTo(titleLb);
            }];
        }
    }
    return self;
}

@end
