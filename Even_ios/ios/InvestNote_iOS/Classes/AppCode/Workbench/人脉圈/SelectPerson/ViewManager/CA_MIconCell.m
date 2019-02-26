
//
//  CA_MAddPersonCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MIconCell.h"

@interface CA_MIconCell ()
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UIImageView* arrowImgView;
@property(nonatomic,strong)UIView* lineView;
@end

@implementation CA_MIconCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.arrowImgView.mas_leading).offset(-5);
        //
        make.width.height.mas_equalTo(30*CA_H_RATIO_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}


-(void)configCell:(NSString*)title image:(UIImage*)image{
    
    self.titleLb.text = title;
    
    if (image) {
        self.iconImgView.image = image;
    }else{
        self.iconImgView.image = kImage(@"head30");
    }
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.image = kImage(@"head30");
    _iconImgView.layer.cornerRadius = 30/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"shape5");
    return _arrowImgView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end

