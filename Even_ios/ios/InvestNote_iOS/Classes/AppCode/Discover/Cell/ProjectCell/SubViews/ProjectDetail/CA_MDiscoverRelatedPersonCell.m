
//
//  CA_MDiscoverRelatedPersonCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonCell.h"
#import "CA_MDiscoverRelatedPersonModel.h"
#import "ButtonLabel.h"

@interface CA_MManageStatusView : UIView
@property (nonatomic,copy) NSString *status;
@property (nonatomic,strong) UIColor *statusColor;
@end

@interface CA_MManageStatusView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *statusLb;
@end

@implementation CA_MManageStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self addSubview:self.bgView];
    [self addSubview:self.statusLb];
}

-(void)setConstraints{
    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.statusLb.sd_layout
    .centerXEqualToView(self.bgView)
    .centerYEqualToView(self.bgView)
    .autoHeightRatio(0);
    [self.statusLb setSingleLineAutoResizeWithMaxWidth:0];
    
}

-(void)setStatus:(NSString *)status{
    _status = status;
    self.statusLb.text = status;
}

-(void)setStatusColor:(UIColor *)statusColor{
    _statusColor = statusColor;
    self.statusLb.textColor = statusColor;
}

-(UILabel *)statusLb{
    if (!_statusLb) {
        _statusLb = [UILabel new];
        [_statusLb configText:@""
                    textColor:CA_H_TINTCOLOR
                         font:14];
    }
    return _statusLb;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#F8F8F8");
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 24*2*CA_H_RATIO_WIDTH, 14*2*CA_H_RATIO_WIDTH) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(2*2*CA_H_RATIO_WIDTH, 2*2*CA_H_RATIO_WIDTH)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 24*2*CA_H_RATIO_WIDTH, 14*2*CA_H_RATIO_WIDTH);
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}
@end

@interface CA_MDiscoverRelatedPersonCell ()
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) CA_MManageStatusView *statusView;
@property (nonatomic,strong) UILabel *legalLb;
@property (nonatomic,strong) ButtonLabel *nickNameLb;
@property (nonatomic,strong) UILabel *moneyLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MDiscoverRelatedPersonCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.companyLb];
    [self.contentView addSubview:self.legalLb];
    [self.contentView addSubview:self.nickNameLb];
    [self.contentView addSubview:self.moneyLb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.detailLb];
    [self setConstraints];
}

-(void)setConstraints{
    
    self.shadowView.sd_layout
    .leftSpaceToView(self.contentView, 9*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 9*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView).offset(1*2*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.contentView).offset(-4*2*CA_H_RATIO_WIDTH);
    
    self.bgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView).offset(2*2*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.contentView).offset(-5*2*CA_H_RATIO_WIDTH);
    
    self.statusView.sd_layout
    .topSpaceToView(self.contentView, 8*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.shadowView)
    .widthIs(24*2*CA_H_RATIO_WIDTH)
    .heightIs(14*2*CA_H_RATIO_WIDTH);
    
    self.companyLb.isAttributedContent = YES;
    self.companyLb.sd_layout
    .leftSpaceToView(self.contentView, 20*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 44*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.companyLb setMaxNumberOfLinesToShow:0];

    self.legalLb.sd_layout
    .leftEqualToView(self.companyLb)
    .topSpaceToView(self.companyLb, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.legalLb setSingleLineAutoResizeWithMaxWidth:0];

    self.nickNameLb.sd_layout
    .leftSpaceToView(self.legalLb, 0)
    .topEqualToView(self.legalLb)
    .rightSpaceToView(self.contentView, 15*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nickNameLb setMaxNumberOfLinesToShow:0];

    self.moneyLb.sd_layout
    .leftEqualToView(self.legalLb)
    .topSpaceToView(self.nickNameLb, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 24*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);

    self.lineView.sd_layout
    .leftEqualToView(self.moneyLb)
    .topSpaceToView(self.moneyLb, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*2*CA_H_RATIO_WIDTH)
    .heightIs(CA_H_LINE_Thickness);

    self.detailLb.isAttributedContent = YES;
    self.detailLb.sd_layout
    .leftEqualToView(self.lineView)
    .topSpaceToView(self.lineView, 5*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.lineView)
    .autoHeightRatio(0);
    [self.detailLb setMaxNumberOfLinesToShow:0];
    
}

-(void)setModel:(CA_MDiscoverRelatedPersonData_list *)model{
    [super setModel:model];
    
    self.companyLb.text = model.enterprise_name;
    
    [self.companyLb changeLineSpaceWithSpace:6];
    
    self.statusView.status = model.status;
    
    self.statusView.statusColor = kColor(model.status_color);
    
    self.legalLb.text = @"法定代表人：";
    
    self.nickNameLb.text = [NSString isValueableString:model.opername]?model.opername:@"暂无";
    
    self.moneyLb.text = [NSString stringWithFormat:@"注册资本：%@",([NSString isValueableString:model.regist_capi]?model.regist_capi:@"暂无")];
    
    self.detailLb.text = [NSString isValueableString:model.position_desc]?model.position_desc:@"暂无";
    
    self.detailLb.text = [self.detailLb.text stringByReplacingOccurrencesOfString:@"," withString:@"，"];
    
    [self.detailLb changeLineSpaceWithSpace:5];
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
    
}

#pragma mark - getter and setter

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.textColor = CA_H_4BLACKCOLOR;
        _detailLb.font = CA_H_FONT_PFSC_Medium(16);
        _detailLb.numberOfLines = 0;
    }
    return _detailLb;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [UILabel new];
        [_moneyLb configText:@""
                      textColor:CA_H_4BLACKCOLOR
                           font:16];
    }
    return _moneyLb;
}
-(ButtonLabel *)nickNameLb{
    if (!_nickNameLb) {
        _nickNameLb = [ButtonLabel new];
        _nickNameLb.numberOfLines = 0;
        [_nickNameLb configText:@""
                     textColor:CA_H_4BLACKCOLOR
                          font:16];
    }
    return _nickNameLb;
}
-(UILabel *)legalLb{
    if (!_legalLb) {
        _legalLb = [UILabel new];
        [_legalLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _legalLb;
}
-(ButtonLabel *)companyLb{
    if (!_companyLb) {
        _companyLb = [ButtonLabel new];
        _companyLb.numberOfLines = 0;
        [_companyLb configText:@""
                     textColor:CA_H_TINTCOLOR
                          font:16];
    }
    return _companyLb;
}
-(CA_MManageStatusView *)statusView{
    if (!_statusView) {
        _statusView = [CA_MManageStatusView new];
    }
    return _statusView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        UIColor *shadowColor = CA_H_SHADOWCOLOR;
        
        _shadowView.layer.cornerRadius = 4*2*CA_H_RATIO_WIDTH;
        _shadowView.layer.backgroundColor = [UIColor whiteColor].CGColor;//shadowColor.CGColor;
        _shadowView.layer.masksToBounds = NO;
        _shadowView.layer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        _shadowView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _shadowView.layer.shadowRadius = 4*CA_H_RATIO_WIDTH;//阴影半径，默认3
    }
    return _shadowView;
}

@end
