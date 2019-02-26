//
//  CA_MNewProjectPlanItemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectPlanItemCell.h"
#import "CA_MProjectModel.h"

@implementation CA_MNewProjectPlanItemCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.sologImgView];
    self.sologImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.contentView addSubview:self.importBtn];
    self.importBtn.sd_layout
    .leftEqualToView(self.sologImgView)
    .bottomEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .heightIs(9*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.iconLb];
    self.iconLb.sd_layout
    .leftEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .centerYEqualToView(self.sologImgView)
    .autoHeightRatio(0);
    
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sologImgView, 5*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.sologImgView)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
//    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:self.tagView];
    self.tagView.sd_layout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.tagLb rightMargin:2*2*CA_H_RATIO_WIDTH];
}

-(void)setModel:(CA_MProjectModel *)model{
    [super setModel:model];
    
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
    
    self.importBtn.hidden = ![NSString isValueableString:model.project_status];
    [self.importBtn setTitle:model.project_status forState:UIControlStateNormal];
    
    self.titleLb.text = model.project_name;
    
    self.tagView.hidden = ![NSString isValueableString:model.project_progress];
    self.tagView.tagLb.text = model.project_progress;
    
    if ([NSString isValueableString:model.project_progress]) {
        CGFloat tagWidth = [self.tagView.tagLb.text widthForFont:CA_H_FONT_PFSC_Light(12)]+7*2*CA_H_RATIO_WIDTH;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH-tagWidth-3*2*CA_H_RATIO_WIDTH];
    }else{
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    }
    
    [self setupAutoHeightWithBottomView:self.sologImgView bottomMargin:5*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter

-(UIButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [UIButton new];
        [_importBtn configTitle:@""
                     titleColor:[UIColor whiteColor]
                           font:10];
        _importBtn.backgroundColor = CA_H_TINTCOLOR;
        _importBtn.alpha = 0.85;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                  CGRectMake(0, 0, 25*2*CA_H_RATIO_WIDTH, 9*2*CA_H_RATIO_WIDTH) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2*2*CA_H_RATIO_WIDTH, 2*2*CA_H_RATIO_WIDTH)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 25*2*CA_H_RATIO_WIDTH, 9*2*CA_H_RATIO_WIDTH);
        maskLayer.path = maskPath.CGPath;
        _importBtn.layer.mask = maskLayer;
    }
    return _importBtn;
}

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

-(CA_MProjectTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MProjectTagView new];
    }
    return _tagView;
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
