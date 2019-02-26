
//
//  CA_MProjectMemberSectionView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectMemberSectionView.h"

@interface CA_MProjectMemberSectionView()
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MProjectMemberSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.bottom.mas_equalTo(self);
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
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _titleLb;
}
@end
