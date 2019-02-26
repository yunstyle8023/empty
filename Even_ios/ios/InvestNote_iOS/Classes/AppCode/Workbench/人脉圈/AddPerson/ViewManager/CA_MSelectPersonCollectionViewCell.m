
//
//  CA_MSelectPersonCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSelectPersonCollectionViewCell.h"

@interface CA_MSelectPersonCollectionViewCell()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* iconImg;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MSelectPersonCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.mas_equalTo(self.contentView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
    
}

-(void)setModel:(CA_MProjectTagModel *)model{
    _model = model;
    
    self.titleLb.text = model.tag_name;
    self.iconImg.hidden = !model.isSelect;
    if (model.isSelect) {
        self.bgView.backgroundColor = CA_H_TINTCOLOR;
        self.titleLb.textColor = kColor(@"#FFFFFF");
    }else{
        self.bgView.backgroundColor = kColor(@"#F8F8F8");
        self.titleLb.textColor = kColor(@"#666666");
    }
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}
-(UIImageView *)iconImg{
    if (_iconImg) {
        return _iconImg;
    }
    _iconImg = [[UIImageView alloc] init];
    _iconImg.image = kImage(@"choosePerson");
    return _iconImg;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:kColor(@"#666666") font:14];
    return _titleLb;
}
@end
