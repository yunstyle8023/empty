//
//  CA_MCommentCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCommentCell.h"
#import "CA_HShowDate.h"

@interface CA_MCommentCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIImageView *logoImgView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UIButton *lookBtn;
@end


@implementation CA_MCommentCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLb];
    [self.bgView addSubview:self.timeLb];
    [self.bgView addSubview:self.topLineView];
    [self.bgView addSubview:self.detailLb];
    [self.bgView addSubview:self.logoImgView];
    [self.bgView addSubview:self.iconLb];
    [self.bgView addSubview:self.bottomLineView];
    [self.bgView addSubview:self.lookBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
//        make.height.mas_equalTo(167*CA_H_RATIO_WIDTH);
        make.bottom.mas_equalTo(self.contentView).offset(-3);
    }];
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bgView).offset(15);
        //
        make.width.height.mas_equalTo(20);
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.logoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLineView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        //
        make.width.height.mas_equalTo(45);
    }];
    
    [self.iconLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.logoImgView);
    }];
    
    [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImgView);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.logoImgView.mas_leading).offset(-10);
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(15);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.lookBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bottomLineView).offset(6);
    }];
    
}

-(CGFloat)configCell:(CA_MMessageDetailModel*)model{
    
    NSString* url = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.creator.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:url] placeholder:kImage(@"head20")];
    
    if (model.ts_create.longValue == 0) {
        self.timeLb.text = @"";
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_create.longValue];
        self.timeLb.text = [CA_HShowDate showDate:date];
    }
    
    self.titleLb.text = model.creator.chinese_name;
    self.detailLb.text = model.title;
    
    if ([NSString isValueableString:model.module_info.module_logo]) {
        NSString* imgUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.module_info.module_logo];
        [self.logoImgView setImageURL:[NSURL URLWithString:imgUrl]];
        self.logoImgView.backgroundColor = kColor(@"#FFFFFF");
        //
        self.iconLb.hidden = YES;
        self.iconLb.text = @"";
    }else{
        self.logoImgView.image = nil;
        self.logoImgView.backgroundColor = kColor(model.module_info.color);
        //
        self.iconLb.hidden = NO;
        self.iconLb.text = [model.module_info.module_name substringToIndex:1];
    }
    
    if (!model.body.check_detail) {//# 是否已读 read/unread
        self.bottomLineView.hidden = NO;
        self.lookBtn.hidden = NO;
    }else{
        self.bottomLineView.hidden = YES;
        self.lookBtn.hidden = YES;
    }
    
    CGFloat height = self.lookBtn.isHidden ? (142)*CA_H_RATIO_WIDTH:(188)*CA_H_RATIO_WIDTH;
    return height;
}

#pragma mark - getter and setter
-(UIButton *)lookBtn{
    if (_lookBtn) {
        return _lookBtn;
    }
    _lookBtn = [[UIButton alloc] init];
    _lookBtn.enabled = NO;
    [_lookBtn configTitle:@"查看详情" titleColor:CA_H_TINTCOLOR font:14];
    return _lookBtn;
}
-(UIImageView *)logoImgView{
    if (_logoImgView) {
        return _logoImgView;
    }
    _logoImgView = [UIImageView new];
    _logoImgView.layer.cornerRadius = 4;
//    _logoImgView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
//    _logoImgView.layer.borderWidth = 1;
    _logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _logoImgView;
}
-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    _detailLb.numberOfLines = 2;
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:16];
    return _detailLb;
}
-(UIView *)bottomLineView{
    if (_bottomLineView) {
        return _bottomLineView;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = CA_H_BACKCOLOR;
    return _bottomLineView;
}
-(UIView *)topLineView{
    if (_topLineView) {
        return _topLineView;
    }
    _topLineView = [[UIView alloc] init];
    _topLineView.backgroundColor = CA_H_BACKCOLOR;
    return _topLineView;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"09:21" textColor:CA_H_9GRAYCOLOR font:14];
    return _timeLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"梁璐" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [UIImageView new];
    _iconImgView.layer.cornerRadius = 20/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [UIView new];
    _bgView.frame = CGRectMake(0, 0, 345*CA_H_RATIO_WIDTH, 167*CA_H_RATIO_WIDTH);
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}

@end
