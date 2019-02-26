
//
//  CA_MNewProjectAbandonCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectAbandonCell.h"
#import "CA_MProjectModel.h"

@implementation CA_MNewProjectAbandonCell

-(void)upView{
    [super upView];

    [self.contentView addSubview:self.sologImgView];
    self.sologImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.contentView addSubview:self.iconLb];
    self.iconLb.sd_layout
    .leftEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .centerYEqualToView(self.sologImgView)
    .autoHeightRatio(0);
    
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sologImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sologImgView).offset(2)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:self.detailLb];
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.titleLb)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MProjectModel *)model{
    
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
    self.detailLb.text = [NSString stringWithFormat:@"放弃原因：%@",([NSString isValueableString:model.abandon_info]?model.abandon_info:@"暂无")];
    
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
        _sologImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _sologImgView;
}

@end
