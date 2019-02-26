
//
//  CA_MDiscoverSponsorDetailMemberCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailMemberCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailMemberCell ()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *positionLb;
@property (nonatomic,strong) UILabel *email;
@property (nonatomic,strong) UILabel *emailLb;
@property (nonatomic,strong) UILabel *tel;
@property (nonatomic,strong) UILabel *telLb;
@end

@implementation CA_MDiscoverSponsorDetailMemberCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.positionLb];
    [self.contentView addSubview:self.email];
    [self.contentView addSubview:self.emailLb];
    [self.contentView addSubview:self.tel];
    [self.contentView addSubview:self.telLb];
    [self setConstrains];
}

-(void)setConstrains{
    
    self.positionLb.sd_layout
    .leftSpaceToView(self.contentView, 17*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.positionLb)
    .widthIs(2*2*CA_H_RATIO_WIDTH)
    .heightIs(8*2*CA_H_RATIO_WIDTH);

    self.email.sd_layout
    .leftEqualToView(self.positionLb)
    .topSpaceToView(self.positionLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.email setSingleLineAutoResizeWithMaxWidth:0];

    self.tel.sd_layout
    .leftSpaceToView(self.contentView, 101*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.email)
    .autoHeightRatio(0);
    [self.tel setSingleLineAutoResizeWithMaxWidth:0];

    self.emailLb.sd_layout
    .leftEqualToView(self.email)
    .topSpaceToView(self.email, 6*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 107*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.emailLb setMaxNumberOfLinesToShow:2];

    self.telLb.sd_layout
    .leftEqualToView(self.tel)
    .topSpaceToView(self.tel, 6*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.telLb setMaxNumberOfLinesToShow:2];
    
}

-(void)setModel:(CA_MDiscoverSponsorMember_list *)model{
    [super setModel:model];
    
    self.positionLb.text = [NSString stringWithFormat:@"%@ %@",model.member_position,model.member_name];
    self.email.text = @"邮箱";
    self.emailLb.text = [NSString isValueableString:model.member_mail]?model.member_mail:@"暂无";
    self.tel.text = @"电话";
    self.telLb.text = [NSString isValueableString:model.member_tel]?model.member_tel:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.emailLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
    
}

#pragma mark - getter and setter
-(UILabel *)telLb{
    if (!_telLb) {
        _telLb = [UILabel new];
        _telLb.numberOfLines = 2;
        [_telLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _telLb;
}
-(UILabel *)tel{
    if (!_tel) {
        _tel = [UILabel new];
        [_tel configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:12];
    }
    return _tel;
}
-(UILabel *)emailLb{
    if (!_emailLb) {
        _emailLb = [UILabel new];
        _emailLb.numberOfLines = 2;
        [_emailLb configText:@""
                 textColor:CA_H_4BLACKCOLOR
                      font:16];
    }
    return _emailLb;
}
-(UILabel *)email{
    if (!_email) {
        _email = [UILabel new];
        [_email configText:@""
                 textColor:CA_H_6GRAYCOLOR
                      font:12];
    }
    return _email;
}
-(UILabel *)positionLb{
    if (!_positionLb) {
        _positionLb = [UILabel new];
        _positionLb.font = CA_H_FONT_PFSC_Medium(16);
        _positionLb.textColor = CA_H_4BLACKCOLOR;
    }
    return _positionLb;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_TINTCOLOR;
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

@end
