//
//  CA_MProjectDetailHistoryCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailHistoryBeginCell.h"

@interface CA_MProjectDetailHistoryBeginCell()

@end

@implementation CA_MProjectDetailHistoryBeginCell

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
    [self.contentView addSubview:self.introduceLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.leading.mas_equalTo(self.contentView).offset(20);
        //
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.circleView);
        make.leading.mas_equalTo(self.circleView.mas_trailing).offset(10);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    
    [self.introduceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
}

//-(void)setModel:(CA_MInvest_history *)model{
//    _model = model;
//    self.titleLb.text = [NSString stringWithFormat:@"%@-%@",model.invest_stage,model.invest_money];
//
//    NSDate *bornDate = [NSDate dateWithTimeIntervalSince1970:model.ts_invest.longValue];
//    NSString* bornDateStr = [bornDate stringWithFormat:@"yyyy.MM.dd"];
//    self.timeLb.text = bornDateStr;
//
//    self.introduceLb.text = model.investor;
//}

-(CGFloat)configCell:(CA_MInvest_history *)model{
    
    self.titleLb.text = [NSString stringWithFormat:@"%@-%@",model.invest_stage,model.invest_money];
    
    NSDate *bornDate = [NSDate dateWithTimeIntervalSince1970:model.ts_invest.longValue];
    NSString* bornDateStr = [bornDate stringWithFormat:@"yyyy.MM.dd"];
    self.timeLb.text = bornDateStr;
    
    self.introduceLb.text = model.investor;
    [self.introduceLb changeLineSpaceWithSpace:5];
    
    NSString *investorStr = [NSString isValueableString:model.investor]?model.investor:@"暂无";
    CGFloat investorHeight = [self getSpaceLabelHeight:investorStr withFont:CA_H_FONT_PFSC_Regular(14) withWidth:CA_H_SCREEN_WIDTH-60*CA_H_RATIO_WIDTH];
    
    return 24*2*CA_H_RATIO_WIDTH+investorHeight;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(UILabel *)introduceLb{
    if (_introduceLb) {
        return _introduceLb;
    }
    _introduceLb = [[UILabel alloc] init];
    _introduceLb.numberOfLines = 0;
    [_introduceLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _introduceLb;
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
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
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

