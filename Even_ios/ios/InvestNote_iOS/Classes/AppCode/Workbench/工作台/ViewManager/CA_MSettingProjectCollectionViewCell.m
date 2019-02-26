//
//  CA_MSettingProjectCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingProjectCollectionViewCell.h"
#import "CA_MSettingType.h"

@interface CA_MSettingProjectCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UIImageView *selectedImgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MSettingProjectCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.selectedImgView];
        [self addSubview:self.titleLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        //
        make.width.height.mas_equalTo(45);
    }];
    
    [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconImgView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    
}

-(void)setModel:(CA_MSettingListModel *)model{
    _model = model;
    
    if ([model.mod_type isEqualToString:SettingType_NoAuthority]) {
        self.iconImgView.image = kImage(@"loadfail_project50");
    }else{
        self.iconImgView.image = kImage(model.mod_type);
    }
    
    self.selectedImgView.hidden = !model.isSelected;
    
    self.titleLb.text = model.mod_name;
    
}

#pragma mark - getter and setter
-(UIImageView *)selectedImgView{
    if (_selectedImgView) {
        return _selectedImgView;
    }
    _selectedImgView = [[UIImageView alloc] init];
    _selectedImgView.image = kImage(@"choose2");
    _selectedImgView.layer.cornerRadius = 45/2;
    _selectedImgView.layer.masksToBounds = YES;
    _selectedImgView.hidden = YES;
    return _selectedImgView;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 45/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _iconImgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}
@end
