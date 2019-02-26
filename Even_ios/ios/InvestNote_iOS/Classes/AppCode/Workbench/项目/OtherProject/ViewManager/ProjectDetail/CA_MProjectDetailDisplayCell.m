//
//  CA_MProjectDetailDisplayCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailDisplayCell.h"
#import "ButtonLabel.h"

@interface CA_MProjectDetailDisplayCell()

@end

@implementation CA_MProjectDetailDisplayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        make.leading.mas_equalTo(self.titleLb.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.contentView);
    }];
    
}

-(void)configCell:(NSString*)title value:(NSString*)valueStr{
    self.titleLb.text = title;
    self.valueLb.text = [NSString isValueableString:valueStr]?valueStr:@"暂无";
}

-(ButtonLabel *)valueLb{
    if (!_valueLb) {
        _valueLb = [ButtonLabel new];
        [_valueLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:16];
    }
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

