//
//  CA_MProjectTagCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTagCollectionViewCell.h"

@interface CA_MProjectTagCollectionViewCell()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIImageView* delImgView;
@end

@implementation CA_MProjectTagCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.delImgView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-30*CA_H_RATIO_WIDTH);
    }];
    
    [self.delImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb.mas_trailing).offset(6);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UIImageView *)delImgView{
    if (_delImgView) {
        return _delImgView;
    }
    _delImgView = [[UIImageView alloc] init];
    _delImgView.image = kImage(@"xTag");
    return _delImgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:kColor(@"#FFFFFF") font:14];
    return _titleLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = CA_H_TINTCOLOR;
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}

@end
