//
//  CA_MProjectProgressStageCollectionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressStageCollectionCell.h"

@interface CA_MProjectProgressStageCollectionCell ()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MProjectProgressStageCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.contentView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImg);
        make.leading.mas_equalTo(self.iconImg.mas_trailing).offset(5);
    }];
}

-(void)setModel:(CA_MApproval_user *)model{
    _model = model;
    
    [self.iconImg setImageWithURL:[NSURL URLWithString:model.avatar]
                          placeholder:kImage(@"head20")];
    
    self.titleLb.text = model.chinese_name;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    [_titleLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _titleLb;
}

-(UIImageView *)iconImg{
    if (_iconImg) {
        return _iconImg;
    }
    _iconImg = [UIImageView new];
    _iconImg.layer.cornerRadius = 20/2;
    _iconImg.layer.masksToBounds = YES;
    return _iconImg;
}
@end
