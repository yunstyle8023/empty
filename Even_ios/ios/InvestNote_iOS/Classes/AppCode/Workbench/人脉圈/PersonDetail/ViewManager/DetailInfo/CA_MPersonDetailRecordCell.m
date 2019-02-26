
//
//  CA_MPersonDetailRecordCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailRecordCell.h"

@interface CA_MPersonDetailRecordCell ()
@property (nonatomic,strong) UIView *circleView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *companyLb;
@property (nonatomic,strong) UILabel *positionLb;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MPersonDetailRecordCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.companyLb];
    [self.contentView addSubview:self.positionLb];
    [self.contentView addSubview:self.detailLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView);
        //
        make.width.height.mas_equalTo(12*CA_H_RATIO_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(1);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.circleView.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.circleView);
    }];
    
    [self.companyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.timeLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.timeLb.mas_bottom).offset(5);
    }];
    
    [self.positionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.companyLb);
        make.top.mas_equalTo(self.companyLb.mas_bottom).offset(5);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.positionLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.positionLb.mas_bottom).offset(5);
    }];
    
}

-(CGFloat)configCell:(CA_MJob_experience*)model
        indexPath:(NSIndexPath*)indexPath
         totalRow:(NSInteger)totalRow{

    if (indexPath.row == totalRow-1) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
    }
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.ts_jod_start.longValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.ts_jod_end.longValue];
    NSString* startDateStr = [startDate stringWithFormat:@"yyyy.MM.dd"];//@"2017.12.12"
    NSString* endDateStr = [endDate stringWithFormat:@"yyyy.MM.dd"];//@"2017.12.12"
    self.timeLb.text = [NSString stringWithFormat:@"%@~%@",startDateStr,endDateStr];
    
    self.companyLb.text = model.company_name;
    
    self.positionLb.text = model.jod_position;
    
    self.detailLb.text = model.job_content;
    
    CGFloat timeH = [self.timeLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    CGFloat companyH = [self.companyLb.text heightForFont:CA_H_FONT_PFSC_Regular(16) width:313];
    CGFloat positionH = [self.positionLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    CGFloat detailH = [self.detailLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat height = timeH + 5 + companyH + 5 + positionH + 5 + detailH + 20;
    return height;
}

#pragma mark - getter and setter
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    _detailLb.numberOfLines = 0;
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _detailLb;
}
-(UILabel *)positionLb{
    if (_positionLb) {
        return _positionLb;
    }
    _positionLb = [[UILabel alloc] init];
    [_positionLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _positionLb;
}
-(UILabel *)companyLb{
    if (_companyLb) {
        return _companyLb;
    }
    _companyLb = [[UILabel alloc] init];
    [_companyLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _companyLb;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _timeLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIView *)circleView{
    if (_circleView) {
        return _circleView;
    }
    _circleView = [[UIView alloc] init];
    _circleView.backgroundColor = CA_H_TINTCOLOR;
    _circleView.layer.cornerRadius = 12*CA_H_RATIO_WIDTH/2;
    _circleView.layer.masksToBounds = YES;
    return _circleView;
}

@end
