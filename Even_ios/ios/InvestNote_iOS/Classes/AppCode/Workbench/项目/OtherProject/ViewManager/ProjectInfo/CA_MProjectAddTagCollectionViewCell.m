
//
//  CA_MProjectAddTagCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectAddTagCollectionViewCell.h"

@interface CA_MProjectAddTagCollectionViewCell()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* addImgView;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MProjectAddTagCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.addImgView];
        [self.contentView addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.addImgView.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
}

#pragma mark - getter and setter
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"添加标签" textColor:CA_H_TINTCOLOR font:14];
    return _titleLb;
}
-(UIImageView *)addImgView{
    if (_addImgView) {
        return _addImgView;
    }
    _addImgView = [[UIImageView alloc] init];
    _addImgView.image = kImage(@"addTag");
    return _addImgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderColor = CA_H_TINTCOLOR.CGColor;
    _bgView.layer.borderWidth = 0.5;
    return _bgView;
}
@end
