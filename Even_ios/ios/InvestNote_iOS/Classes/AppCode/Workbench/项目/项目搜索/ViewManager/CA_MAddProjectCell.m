//
//  CA_MAddProjectCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/20.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MAddProjectCell.h"
#import "CA_MSelectModel.h"

@interface CA_MAddProjectCell()

@end

@implementation CA_MAddProjectCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    self.iconImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.iconImgView, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 6*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.introduceLb];
    self.introduceLb.sd_layout
    .leftSpaceToView(self.iconImgView, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.iconImgView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MSelectModel *)model{
    [super setModel:model];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    self.titleLb.text = model.project_name;
    self.introduceLb.text = model.brief_intro;
}

#pragma mark - getter and setter

-(UILabel *)introduceLb{
    if (!_introduceLb) {
        _introduceLb = [UILabel new];
        [_introduceLb
         configText:@""
         textColor:CA_H_9GRAYCOLOR
         font:14];
    }
    return _introduceLb;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 4;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
@end
