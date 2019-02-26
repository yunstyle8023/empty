//
//  CA_MNewProjectAttentionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectAttentionCell.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectAttentionCell ()
@property (nonatomic,strong) UIImageView *sologanImgView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MNewProjectAttentionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.sologanImgView];
        self.sologanImgView.sd_layout
        .centerXEqualToView(self.contentView)
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
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(self.sologanImgView, 5*2*CA_H_RATIO_WIDTH)
        .bottomEqualToView(self.contentView)
        .heightIs(20*CA_H_RATIO_WIDTH);
        [self.titleLb setMaxNumberOfLinesToShow:1];
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
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:14];
    }
    return _titleLb;
}

@end
