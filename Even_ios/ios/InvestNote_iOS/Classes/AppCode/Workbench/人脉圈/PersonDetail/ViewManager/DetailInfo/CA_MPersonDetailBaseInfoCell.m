//
//  CA_MPersonDetailBaseInfoCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailBaseInfoCell.h"

@interface CA_MPersonDetailBaseInfoCell ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *valueLb;
@end

@implementation CA_MPersonDetailBaseInfoCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.valueLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView);
    }];
    
    [self.valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
}

-(CGFloat)configCell:(CA_MTypeModel*)model{
    self.titleLb.text = model.title;
    self.valueLb.text = [NSString isValueableString:model.value] ? model.value : @"暂无";
    return [@"标准高度" heightForFont:CA_H_FONT_PFSC_Regular(16) width:180] + 15;
}

-(UILabel *)valueLb{
    if (_valueLb) {
        return _valueLb;
    }
    _valueLb = [[UILabel alloc] init];
    [_valueLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _valueLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_9GRAYCOLOR font:16];
    return _titleLb;
}

@end
