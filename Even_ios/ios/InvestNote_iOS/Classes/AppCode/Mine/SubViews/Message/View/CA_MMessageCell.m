
//
//  CA_MMessageCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMessageCell.h"
#import "CA_MMessageModel.h"
#import "CA_HShowDate.h"

@interface CA_MMessageCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UIView *countView;
@property (nonatomic,strong) UILabel *countLb;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MMessageCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.countLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(self.contentView).offset(15);
        //
        make.width.height.mas_equalTo(50);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.iconImgView);
        //
        make.width.height.mas_equalTo(16);
    }];
    
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.countView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(15);
        make.top.mas_equalTo(self.iconImgView);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(7);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

-(void)setModel:(CA_MMessage *)model{
    
    [self.iconImgView setImage:kImage(model.imageName)];
    
    if (model.count.intValue > 0) {
        self.countView.hidden = NO;
        self.countLb.hidden = NO;
        self.countLb.text = model.count.intValue >= 99 ? @"99" : [NSString stringWithFormat:@"%@",model.count];
    }else{
        self.countView.hidden = YES;
        self.countLb.hidden = YES;
        self.countLb.text = @"";
    }
    
    self.titleLb.text = model.projectName;
    
    if (model.ts_update.longValue == 0) {
        self.timeLb.text = @"";
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_update.longValue];
        self.timeLb.text = [CA_HShowDate showDate:date];
    }
    
    self.detailLb.text = model.title;
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

-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:10];
    return _timeLb;
}

-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:13];
    return _detailLb;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}

-(UILabel *)countLb{
    if (_countLb) {
        return _countLb;
    }
    _countLb = [[UILabel alloc] init];
    [_countLb configText:@"" textColor:kColor(@"#FFFFFF") font:10];
    return _countLb;
}

-(UIView *)countView{
    if (_countView) {
        return _countView;
    }
    _countView = [[UIView alloc] init];
    _countView.backgroundColor = kColor(@"#FF6969");
    _countView.layer.cornerRadius = 8;
    _countView.layer.masksToBounds = YES;
    return _countView;
}

-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImgView.backgroundColor = kRandomColor;
    _iconImgView.layer.cornerRadius = 50/2;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}

@end
