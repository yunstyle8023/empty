//
//  CA_MPersonDetailAddRelevanceCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailAddRelevanceCell.h"

@interface CA_MPersonDetailAddRelevanceCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *addImgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MPersonDetailAddRelevanceCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.addImgView];
    [self.contentView addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.leading.mas_equalTo(self.bgView.mas_trailing).offset(10);
    }];
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"添加关联项目" textColor:CA_H_9GRAYCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)addImgView{
    if (_addImgView) {
        return _addImgView;
    }
    _addImgView = [[UIImageView alloc] init];
    _addImgView.image = kImage(@"add4");
    return _addImgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGRect rect = CGRectMake(20, 4, 50*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}
@end
