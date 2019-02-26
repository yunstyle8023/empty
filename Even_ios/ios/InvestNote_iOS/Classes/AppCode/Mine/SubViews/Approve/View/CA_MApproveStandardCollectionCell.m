//
//  CA_MApproveStandardCollectionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveStandardCollectionCell.h"

@interface CA_MApproveStandardCollectionCell ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MApproveStandardCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
    }];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    _titleLb.numberOfLines = 0;
    return _titleLb;
}
@end
