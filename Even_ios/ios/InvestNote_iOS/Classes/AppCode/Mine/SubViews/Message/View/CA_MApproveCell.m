//
//  CA_MApproveCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveCell.h"
#import "CA_HShowDate.h"

@interface CA_MApproveCell (){
    CGFloat _bgViewHeight;
    CGFloat _contentsViewHeight;
}
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIImageView *logoImgView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UIView *contentsView;
@property (nonatomic,strong) UILabel *resultLb;
@property (nonatomic,strong) UILabel *resultDetailLb;
@property (nonatomic,strong) UILabel *reasonLb;
@property (nonatomic,strong) UILabel *reasonDetailLb;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UIButton *lookBtn;
@end

@implementation CA_MApproveCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLb];
    [self.bgView addSubview:self.timeLb];
    [self.bgView addSubview:self.contentsView];
    [self.bgView addSubview:self.resultLb];
    [self.bgView addSubview:self.resultDetailLb];
    [self.bgView addSubview:self.reasonLb];
    [self.bgView addSubview:self.reasonDetailLb];
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
        make.height.mas_equalTo(_bgViewHeight);
    }];
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bgView).offset(16);
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
        make.top.mas_equalTo(self.topLineView.mas_bottom).offset(16);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        //
        make.width.height.mas_equalTo(46);
    }];
    
    [self.iconLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.logoImgView);
    }];
    
    [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImgView);
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.logoImgView.mas_leading).offset(-10);
    }];
    
    [self.contentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(15);
        //
        make.height.mas_equalTo(_contentsViewHeight*CA_H_RATIO_WIDTH);
    }];
    
    [self.resultLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentsView).offset(10);
        make.top.mas_equalTo(self.contentsView).offset(10);
//        make.trailing.mas_equalTo(self.contentsView).offset(-10);
        make.width.mas_equalTo(35);
    }];

    [self.resultDetailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.resultLb.mas_trailing);
        make.top.mas_equalTo(self.resultLb);
        make.trailing.mas_equalTo(self.contentsView).offset(-10);
    }];
    
    [self.reasonLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentsView).offset(10);
        make.top.mas_equalTo(self.resultLb.mas_bottom).offset(5);
//        CGFloat width = [@"理由:" widthForFont:CA_H_FONT_PFSC_Regular(14)];
        make.width.mas_equalTo(35);
    }];
    
    [self.reasonDetailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.reasonLb.mas_trailing);
        make.top.mas_equalTo(self.reasonLb);
        make.trailing.mas_equalTo(self.contentsView).offset(-10);
    }];

    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_contentsViewHeight>0) {
            make.top.mas_equalTo(self.contentsView.mas_bottom).offset(15);
        }else{
            make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(16);
        }
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];

    [self.lookBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).offset(10-4);
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
        NSString* imgUrl = @"";
        if ([model.module_info.module_logo hasPrefix:@"http"]) {
            imgUrl = model.module_info.module_logo;
        }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.module_info.module_logo];
        }
        
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

    CGFloat resultHeight = 0;
    if ([NSString isValueableString:model.body.approval_result]) {
        self.resultLb.hidden = NO;
        self.resultDetailLb.hidden = NO;
        self.resultDetailLb.text = [NSString stringWithFormat:@"%@",model.body.approval_result];
        self.resultDetailLb.textColor = kColor(model.body.color);
        resultHeight = [model.body.approval_result heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH];
    }else{
        self.resultLb.hidden = YES;
        self.resultDetailLb.hidden = YES;
        self.resultDetailLb.text = @"";
        self.resultDetailLb.textColor = kColor(@"#FFFFFF");
        resultHeight = 0;
    }
    
    CGFloat reasonHeight = 0;
    if ([NSString isValueableString:model.body.approval_reason]) {
        self.reasonLb.hidden = NO;
        self.reasonDetailLb.hidden = NO;
//        self.reasonLb.text = @"理由:";
        self.reasonDetailLb.text = model.body.approval_reason;
        
        reasonHeight = [model.body.approval_reason heightForFont:CA_H_FONT_PFSC_Regular(14) width:127];
    }else{
        self.reasonLb.hidden = YES;
        self.reasonDetailLb.hidden = YES;
//        self.reasonLb.text = @"";
        
        reasonHeight = 0;
    }
    
    _contentsViewHeight = 0.;
    
    if (resultHeight>0) {
        _contentsViewHeight = _contentsViewHeight+ 10+resultHeight;
    }
    if (reasonHeight>0) {
        _contentsViewHeight = _contentsViewHeight+ 10+reasonHeight;
    }
    if (_contentsViewHeight>0) {
        _contentsViewHeight = _contentsViewHeight+10;
    }
    
    _bgViewHeight = 0.;
    
    _bgViewHeight = 122+_contentsViewHeight+56-10;
    
    if (_contentsViewHeight>0) {
        _bgViewHeight = _bgViewHeight+16;
    }
    
    [self layoutIfNeeded];
    
    return _bgViewHeight+20+3;
}

#pragma mark - getter and setter
-(UILabel *)reasonDetailLb{
    if (_reasonDetailLb) {
        return _reasonDetailLb;
    }
    _reasonDetailLb = [UILabel new];
    _reasonDetailLb.numberOfLines = 2;
    [_reasonDetailLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _reasonDetailLb;
}
-(UILabel *)reasonLb{
    if (_reasonLb) {
        return _reasonLb;
    }
    _reasonLb = [UILabel new];
    [_reasonLb configText:@"理由:" textColor:CA_H_4BLACKCOLOR font:14];
    return _reasonLb;
}
-(UILabel *)resultDetailLb{
    if (_resultDetailLb) {
        return _resultDetailLb;
    }
    _resultDetailLb = [UILabel new];
    [_resultDetailLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _resultDetailLb;
}
-(UILabel *)resultLb{
    if (_resultLb) {
        return _resultLb;
    }
    _resultLb = [UILabel new];
    [_resultLb configText:@"结果:" textColor:CA_H_4BLACKCOLOR font:14];
    return _resultLb;
}
-(UIView *)contentsView{
    if (_contentsView) {
        return _contentsView;
    }
    _contentsView = [UIView new];
    _contentsView.backgroundColor = kColor(@"#F8F8F8");
    _contentsView.layer.cornerRadius = 2;
    _contentsView.layer.masksToBounds = YES;
    return _contentsView;
}
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
    _logoImgView.layer.borderColor = CA_H_BACKCOLOR.CGColor;
    _logoImgView.layer.borderWidth = 1;
    _logoImgView.layer.masksToBounds = YES;
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
//    _bgView.frame = CGRectMake(0, 0, 345*CA_H_RATIO_WIDTH, 247*CA_H_RATIO_WIDTH);
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _bgView.layer.shadowOpacity = 0.5f;
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.shadowOpacity = 0.5;
    return _bgView;
}
@end
