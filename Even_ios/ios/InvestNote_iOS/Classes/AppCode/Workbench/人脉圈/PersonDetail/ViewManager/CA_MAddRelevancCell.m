//
//  CA_MAddRelevancCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddRelevancCell.h"

@interface CA_MAddRelevancCell ()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIImageView* selectImgView;
@property(nonatomic,strong)UIView* lineView;
@end


@implementation CA_MAddRelevancCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.selectImgView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
        //
        make.width.height.mas_equalTo(45);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(10);
    }];
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.iconImgView);
        make.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

-(void)setModel:(NSObject *)model{
    [super setModel:model];
    
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIImageView *)selectImgView{
    if (_selectImgView) {
        return _selectImgView;
    }
    _selectImgView = [[UIImageView alloc] init];
    _selectImgView.image = kImage(@"choose");
    return _selectImgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"抖音短视频" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 4;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
    _iconImgView.layer.borderWidth = 0.5;
    _iconImgView.backgroundColor = [UIColor redColor];
    return _iconImgView;
}

@end
