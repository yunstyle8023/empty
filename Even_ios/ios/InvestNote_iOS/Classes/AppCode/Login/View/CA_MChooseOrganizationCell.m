
//
//  CA_MChooseOrganizationCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MChooseOrganizationCell.h"

@interface CA_MChooseOrganizationCell ()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MChooseOrganizationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(CA_H_LINE_Thickness);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(275*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(72*CA_H_RATIO_WIDTH);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.centerY.mas_equalTo(self.bgView);
        //
        make.width.height.mas_equalTo(40);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.borderColor = kColor(@"#ECEDF5").CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        [_titleLb configText:@"经纬中国" textColor:kColor(@"#444444 ") font:16];
    }
    return _titleLb;
}
@end
