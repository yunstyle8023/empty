//
//  CA_MPersonDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailHeaderView.h"

@interface CA_MPersonDetailHeaderView ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *nickNameLb;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MPersonDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = kColor(@"#FFFFFF");
    [self addSubview:self.iconImgView];
    [self addSubview:self.nickNameLb];
    [self addSubview:self.detailLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.centerX.mas_equalTo(self);
        //
        make.width.height.mas_equalTo(65*CA_H_RATIO_WIDTH);
    }];
    [self.nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLb.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self);
    }];
    
}

-(void)setModel:(CA_MPersonDetailModel *)model{
    _model = model;

    NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.human_detail.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head65")];

    self.nickNameLb.text = model.human_detail.chinese_name;
    
    NSString* area = @"";
    model.human_detail.area = [model.human_detail.area stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![NSString isValueableString:model.human_detail.area] ||
        [model.human_detail.area isEqualToString:@"|"]) {
        area = @"暂无";
    }else{
        area = model.human_detail.area;
    }
    
    if ([area rangeOfString:@"|"].location == NSNotFound) {
        self.detailLb.text = [NSString stringWithFormat:@"%@ | %@ | %@",area,model.human_detail.age.longValue<=-2208988800?@"暂无":model.human_detail.age,model.human_detail.gender];
    } else {
        self.detailLb.text = [NSString stringWithFormat:@"%@.%@ | %@ | %@",[[area componentsSeparatedByString:@"|"] firstObject],[[area componentsSeparatedByString:@"|"] lastObject],model.human_detail.age.longValue<=-2208988800?@"暂无":model.human_detail.age,model.human_detail.gender];
    }
    
}

- (NSTimeInterval)timeWithTimeIntervalString:(NSString *)timeString{
    if ([timeString isEqualToString:@"选择"]) {
        return -2208988800;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:timeString];
    return birthdayDate.timeIntervalSince1970;
}

-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _detailLb;
}
-(UILabel *)nickNameLb{
    if (_nickNameLb) {
        return _nickNameLb;
    }
    _nickNameLb = [[UILabel alloc] init];
    [_nickNameLb configText:@"" textColor:CA_H_4BLACKCOLOR font:18];
    return _nickNameLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 65*CA_H_RATIO_WIDTH/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}

@end
