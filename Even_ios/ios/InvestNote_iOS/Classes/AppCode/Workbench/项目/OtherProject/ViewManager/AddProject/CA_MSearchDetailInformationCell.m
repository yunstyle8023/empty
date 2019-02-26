//
//  CA_MSearchDetailInformationCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailInformationCell.h"

@interface CA_MSearchDetailInformationCell()

@end

@implementation CA_MSearchDetailInformationCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.companyLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(50);
    }];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.leading.mas_equalTo(self.contentView).offset(28);
        make.width.height.mas_equalTo(12);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.companyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
}

-(CGFloat)configCell:(CA_MInvest_history*)model{
    self.titleLb.text = [NSString stringWithFormat:@"%@-%@",model.invest_stage,model.invest_money];
    self.timeLb.text = model.invest_date;
    self.companyLb.text = model.investor;

    CGFloat titleHeight = [self.titleLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:295];
    CGFloat companyHeight = [self.companyLb.text heightForFont:CA_H_FONT_PFSC_Regular(12) width:295];
    CGFloat height = titleHeight+5+companyHeight+15;
    
    return height;
}

#pragma mark - getter and setter
-(UILabel *)companyLb{
    if (_companyLb) {
        return _companyLb;
    }
    _companyLb = [[UILabel alloc] init];
    [_companyLb configText:@"" textColor:CA_H_9GRAYCOLOR font:12];
    _companyLb.numberOfLines = 0;
    return _companyLb;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:12];
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
-(UIView *)circleView{
    if (_circleView) {
        return _circleView;
    }
    _circleView = [[UIView alloc] init];
    _circleView.backgroundColor = CA_H_TINTCOLOR;
    _circleView.layer.cornerRadius = 12/2;
    _circleView.layer.masksToBounds = YES;
    return _circleView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end
