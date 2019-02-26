//
//  CA_MProjectTagLabel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTagLabel.h"

@interface CA_MProjectTagLabel()
@property(nonatomic,strong)UILabel* lb;
@end

@implementation CA_MProjectTagLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(@"#EFF1FF");
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        [self addSubview:self.lb];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(5);
        make.trailing.mas_equalTo(self).offset(-5);
        make.top.mas_equalTo(self).offset(1);
        make.bottom.mas_equalTo(self).offset(-1);
    }];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.lb.text = title;
}
-(UILabel *)lb{
    if (_lb) {
        return _lb;
    }
    _lb = [[UILabel alloc] init];
    [_lb configText:@"" textColor:CA_H_TINTCOLOR font:12];
    return _lb;
}

@end
