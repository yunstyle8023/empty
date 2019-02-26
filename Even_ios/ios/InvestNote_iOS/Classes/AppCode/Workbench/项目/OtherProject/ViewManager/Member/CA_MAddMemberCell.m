//
//  CA_MAddMemberCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddMemberCell.h"
#import "CA_MProjectMemberModel.h"

@interface CA_MAddMemberCell()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* iconLb;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIImageView* selectImgView;
@property(nonatomic,strong)UIView* lineView;
@end

@implementation CA_MAddMemberCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self addSubview:self.iconLb];
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
        make.width.height.mas_equalTo(50);
    }];
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.iconImgView);
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

-(void)setModel:(CA_MMemberModel *)model{
    [super setModel:model];
    self.titleLb.text = model.chinese_name;
    
    if ([NSString isValueableString:model.avatar]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar];
        [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head50")];
        self.iconImgView.backgroundColor = kColor(@"#FFFFFF");
        //
        self.iconLb.hidden = YES;
        self.iconLb.text = @"";
    }else{
        self.iconImgView.image = nil;
        self.iconImgView.backgroundColor = kColor(model.abatar_color);
        //
        self.iconLb.hidden = NO;
        self.iconLb.text = [model.chinese_name substringToIndex:1];
    }
    
    self.selectImgView.hidden = model.isSelected;
}

#pragma mark - getter and setter
-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
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
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 50/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
    _iconImgView.layer.borderWidth = 0.5;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
@end
