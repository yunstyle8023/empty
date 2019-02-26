
//
//  CA_MNewProjectStoreCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectStoreCell.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectStoreCell ()
@property (nonatomic,strong) UIImageView *sologanImgView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *typeLb;
@property (nonatomic,strong) UILabel *introLb;
@end

@implementation CA_MNewProjectStoreCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.sologanImgView];
        self.sologanImgView.sd_layout
        .leftEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
        .widthIs(25*2*CA_H_RATIO_WIDTH)
        .heightEqualToWidth();
        
        [self.contentView addSubview:self.iconLb];
        self.iconLb.sd_layout
        .leftEqualToView(self.sologanImgView)
        .rightEqualToView(self.sologanImgView)
        .centerYEqualToView(self.sologanImgView)
        .autoHeightRatio(0);
        
        [self.contentView addSubview:self.titleLb];
        self.titleLb.sd_layout
        .topEqualToView(self.sologanImgView)
        .leftSpaceToView(self.sologanImgView, 5*2*CA_H_RATIO_WIDTH)
        .rightEqualToView(self.contentView)
        .heightIs(22*CA_H_RATIO_WIDTH);
        
        [self.contentView addSubview:self.typeLb];
        self.typeLb.sd_layout
        .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
        .leftEqualToView(self.titleLb)
        .rightEqualToView(self.contentView)
        .heightIs(20*CA_H_RATIO_WIDTH);
        
        [self.contentView addSubview:self.introLb];
        self.introLb.sd_layout
        .topSpaceToView(self.typeLb, 2*2*CA_H_RATIO_WIDTH)
        .leftEqualToView(self.typeLb)
        .rightEqualToView(self.contentView)
        .heightIs(20*CA_H_RATIO_WIDTH);
        
    }
    return self;
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
        
        [self.sologanImgView setImageURL:[NSURL URLWithString:logoUrl]];
        self.sologanImgView.backgroundColor = CA_H_BACKCOLOR;
    }else {
        [self.sologanImgView setImageURL:[NSURL URLWithString:@""]];
        self.sologanImgView.backgroundColor = kColor(model.project_color);
    }
    self.titleLb.text = model.project_name;
    self.typeLb.text = [NSString isValueableString:model.brief_intro]?model.brief_intro:@"暂无";
    self.introLb.text = [NSString stringWithFormat:@"%@-%@ | %@-%@ | %@",
                          [NSString isValueableString:[model.project_area firstObject]]?[model.project_area firstObject]:@"暂无",
                          [NSString isValueableString:[model.project_area lastObject]]?[model.project_area lastObject]:@"暂无",
                          [NSString isValueableString:model.category.parent_category_name]?model.category.parent_category_name:@"暂无",
                          [NSString isValueableString:model.category.child_category_name]?model.category.child_category_name:@"暂无",
                          [NSString isValueableString:model.invest_stage]?model.invest_stage:@"暂无"];
}

-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [UILabel new];
    _iconLb.textAlignment = NSTextAlignmentCenter;
    [_iconLb configText:@""
              textColor:kColor(@"#FFFFFF")
                   font:20];
    return _iconLb;
}

-(UIImageView *)sologanImgView{
    if (!_sologanImgView) {
        _sologanImgView = [UIImageView new];
        _sologanImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sologanImgView.layer.masksToBounds = YES;
        _sologanImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sologanImgView;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 1;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

-(UILabel *)typeLb{
    if (!_typeLb) {
        _typeLb = [UILabel new];
        _typeLb.numberOfLines = 1;
        [_typeLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _typeLb;
}

-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        _introLb.numberOfLines = 1;
        [_introLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _introLb;
}

@end
