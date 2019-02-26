
//
//  CA_MDiscoverProjectDetailInfoCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailInfoCell.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverProjectDetailInfoCell ()
@property (nonatomic,strong) UILabel *introLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *company;//公司名称
//@property (nonatomic,strong) ButtonLabel *companyLb;
@property (nonatomic,strong) UILabel *representative;//法定代表人
//@property (nonatomic,strong) ButtonLabel *representativeLb;
@property (nonatomic,strong) UILabel *time;//注册时间
@property (nonatomic,strong) UILabel *timeLb;
@end

@implementation CA_MDiscoverProjectDetailInfoCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.introLb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.company];
    [self.contentView addSubview:self.companyLb];
    [self.contentView addSubview:self.representative];
    [self.contentView addSubview:self.representativeLb];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.timeLb];
    [self setConstraints];
}

-(void)setConstraints{
    self.introLb.isAttributedContent = YES;
    self.introLb.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.introLb setMaxNumberOfLinesToShow:0];
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.introLb, 7*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
    self.company.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.lineView, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.company setSingleLineAutoResizeWithMaxWidth:0];
    
    self.companyLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.company)
    .autoHeightRatio(0);
    [self.companyLb setMaxNumberOfLinesToShow:0];
    
    self.representative.sd_layout
    .leftEqualToView(self.company)
    .topSpaceToView(self.companyLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.representative setSingleLineAutoResizeWithMaxWidth:0];

    self.representativeLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.representative)
    .autoHeightRatio(0);
    [self.representativeLb setMaxNumberOfLinesToShow:0];

    self.time.sd_layout
    .leftEqualToView(self.representative)
    .topSpaceToView(self.representativeLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.time setSingleLineAutoResizeWithMaxWidth:0];

    self.timeLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.time)
    .autoHeightRatio(0);
    
}

-(void)setModel:(CA_MDiscoverProjectDetailModel *)model{
    [super setModel:model];
    
    self.introLb.text = [NSString isValueableString:model.enterprise_intro]?model.enterprise_intro:@"暂无";
    
    [self.introLb changeLineSpaceWithSpace:7];
    
    self.company.text = @"公司名称";
    
    self.companyLb.text = model.enterprise_name;
    
    if ([NSString isValueableString:model.enterprise_keyno]) {
        self.companyLb.textColor = CA_H_TINTCOLOR;
    }else {
        self.companyLb.textColor = CA_H_4BLACKCOLOR;
    }
    
    self.representative.text = @"法定代表人";
    
    [NSString isValueableString:model.oper_name] ? (self.representativeLb.userInteractionEnabled = YES) : (self.representativeLb.userInteractionEnabled = NO);
    
    self.representativeLb.text = [NSString isValueableString:model.oper_name]?model.oper_name:@"暂无";
    
    if ([NSString isValueableString:model.oper_name]) {
        self.representativeLb.textColor = CA_H_TINTCOLOR;
    }else {
        self.representativeLb.textColor = CA_H_4BLACKCOLOR;
    }
    
    self.time.text = @"注册时间";
    
    if (model.company_register_date.intValue == 0) {
        self.timeLb.text = @"暂无";
    }else {
        NSDate *project_publish_date = [NSDate dateWithTimeIntervalSince1970:model.company_register_date.longValue];
        self.timeLb.text = [project_publish_date stringWithFormat:@"yyyy.MM.dd"];
    }
    
    self.lineView.hidden = NO;
    
    [self setupAutoHeightWithBottomView:self.timeLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
    
}

#pragma mark - getter and setter

-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                     textColor:CA_H_4BLACKCOLOR
                          font:16];
    }
    return _timeLb;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel new];
        [_time configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:16];
    }
    return _time;
}
-(ButtonLabel *)representativeLb{
    if (!_representativeLb) {
        _representativeLb = [ButtonLabel new];
        _representativeLb.numberOfLines = 0;
        [_representativeLb configText:@""
                      textColor:CA_H_TINTCOLOR
                           font:16];
    }
    return _representativeLb;
}
-(UILabel *)representative{
    if (!_representative) {
        _representative = [UILabel new];
        [_representative configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:16];
    }
    return _representative;
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
-(UILabel *)company{
    if (!_company) {
        _company = [UILabel new];
        [_company configText:@""
                   textColor:CA_H_6GRAYCOLOR
                        font:16];
    }
    return _company;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
        _lineView.hidden = YES;
    }
    return _lineView;
}
-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        _introLb.numberOfLines = 0;
        [_introLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:15];
    }
    return _introLb;
}

@end
