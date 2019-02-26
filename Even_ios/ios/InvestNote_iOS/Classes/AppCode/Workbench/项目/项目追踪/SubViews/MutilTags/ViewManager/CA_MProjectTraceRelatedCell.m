//
//  CA_MProjectTraceRelatedCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceRelatedCell.h"
#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MProjectTraceRelatedCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.sloganImgView];
    self.sloganImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.roundLb];
    self.roundLb.sd_layout
    .leftSpaceToView(self.titleLb, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    [self.roundLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.contentView addSubview:self.introduceLb];
    self.introduceLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.introduceLb setMaxNumberOfLinesToShow:2];
    
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.titleLb)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}


-(void)setModel:(CA_MDiscoverCompatible_project_list *)model{
    [super setModel:model];
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    self.roundLb.text = [NSString isValueableString:model.invest_stage]?model.invest_stage:@"暂无";
    
    self.introduceLb.text = [NSString isValueableString:model.biref_intro]?model.biref_intro:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.introduceLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}


#pragma mark - getter and setter

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)introduceLb{
    if (!_introduceLb) {
        _introduceLb = [[UILabel alloc] init];
        _introduceLb.numberOfLines = 2;
        [_introduceLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _introduceLb;
}

-(UILabel *)roundLb{
    if (!_roundLb) {
        _roundLb = [[UILabel alloc] init];
        _roundLb.numberOfLines = 1;
        [_roundLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _roundLb;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.numberOfLines = 1;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.layer.cornerRadius = 4;
        _sloganImgView.layer.masksToBounds = YES;
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sloganImgView;
}
@end
