
//
//  CA_MProjectNoManagerCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectNoManagerCell.h"

@interface CA_MProjectNoManagerCell ()
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MProjectNoManagerCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"暂无主管" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}
@end
