
//
//  CA_MSystemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSystemCell.h"
#import "CA_MMessageDetailModel.h"
#import "CA_HShowDate.h"

@interface CA_MSystemCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MSystemCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLb];
    [self.bgView addSubview:self.timeLb];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.detailLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
//        make.height.mas_equalTo(98*CA_H_RATIO_WIDTH);
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
        make.trailing.mas_equalTo(self.bgView).offset(-5);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.centerY.mas_equalTo(self.titleLb);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];

    [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
    }];
}

-(void)setModel:(CA_MMessageDetailModel *)model{
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
}

#pragma mark - getter and setter
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    _detailLb.numberOfLines = 2;
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:16];
    return _detailLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _timeLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
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
    _bgView.frame = CGRectMake(0, 0, 345*CA_H_RATIO_WIDTH, 98*CA_H_RATIO_WIDTH);
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}

@end
