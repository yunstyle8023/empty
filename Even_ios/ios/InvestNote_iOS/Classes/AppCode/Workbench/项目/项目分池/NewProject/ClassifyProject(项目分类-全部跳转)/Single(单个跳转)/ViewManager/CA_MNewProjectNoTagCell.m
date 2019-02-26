//
//  CA_MNewProjectNoTagCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectNoTagCell.h"
#import "CA_MProjectModel.h"

@interface CA_MNewProjectNoTagCell ()

@end

@implementation CA_MNewProjectNoTagCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.sologImgView];
    [self.contentView addSubview:self.iconLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.typeLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.lineView];
}

-(void)setConstraints{
    self.sologImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.iconLb.sd_layout
    .leftEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .centerYEqualToView(self.sologImgView)
    .autoHeightRatio(0);
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.sologImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sologImgView)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    
    self.typeLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    self.detailLb.sd_layout
    .leftEqualToView(self.typeLb)
    .topSpaceToView(self.typeLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    self.lineView.sd_layout
    .leftEqualToView(self.titleLb)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
     
}

-(void)setModel:(CA_MProjectModel *)model{
    _model = model;
    
    self.iconLb.hidden = [NSString isValueableString:model.project_logo];
    self.iconLb.text = [model.project_name substringToIndex:1];
    
    if ([NSString isValueableString:model.project_logo]) {
        NSString* logoUrl = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            logoUrl = model.project_logo;
        }else{
            logoUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        
        [self.sologImgView setImageURL:[NSURL URLWithString:logoUrl]];
        self.sologImgView.backgroundColor = CA_H_BACKCOLOR;
    }else {
        [self.sologImgView setImageURL:[NSURL URLWithString:@""]];
        self.sologImgView.backgroundColor = kColor(model.project_color);
    }
    
    self.titleLb.text = model.project_name;
    self.typeLb.text = [NSString isValueableString:model.brief_intro]?model.brief_intro:@"暂无";
    self.detailLb.text = [NSString stringWithFormat:@"%@-%@ | %@-%@ | %@",
                          [NSString isValueableString:[model.project_area firstObject]]?[model.project_area firstObject]:@"暂无",
                          [NSString isValueableString:[model.project_area lastObject]]?[model.project_area lastObject]:@"暂无",
                          [NSString isValueableString:model.category.parent_category_name]?model.category.parent_category_name:@"暂无",
                          [NSString isValueableString:model.category.child_category_name]?model.category.child_category_name:@"暂无",
                          [NSString isValueableString:model.invest_stage]?model.invest_stage:@"暂无"];
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter

-(UILabel *)iconLb{
    if (!_iconLb) {
        _iconLb = [UILabel new];
        _iconLb.textAlignment = NSTextAlignmentCenter;
        [_iconLb configText:@""
                  textColor:kColor(@"#FFFFFF")
                       font:20];
    }
    return _iconLb;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _detailLb;
}

-(UILabel *)typeLb{
    if (!_typeLb) {
        _typeLb = [UILabel new];
        [_typeLb configText:@""
                    textColor:CA_H_9GRAYCOLOR
                         font:14];
    }
    return _typeLb;
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

-(UIImageView *)sologImgView{
    if (!_sologImgView) {
        _sologImgView = [UIImageView new];
        _sologImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sologImgView.layer.masksToBounds = YES;
        _sologImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sologImgView;
}

@end
