
//
//  CA_MNewProjectPlanCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectPlanCell.h"
#import "CA_MProjectTagView.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectPlanCell ()
@property (nonatomic,strong) UIImageView *sologanImgView;
@property (nonatomic,strong) UILabel *iconLb;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CA_MProjectTagView *tagView;
@property (nonatomic,strong) UIButton *importBtn;
@end

@implementation CA_MNewProjectPlanCell

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
        
        [self.contentView addSubview:self.importBtn];
        self.importBtn.sd_layout
        .leftEqualToView(self.sologanImgView)
        .bottomEqualToView(self.sologanImgView)
        .rightEqualToView(self.sologanImgView)
        .heightIs(9*2*CA_H_RATIO_WIDTH);
        
        [self.contentView addSubview:self.titleLb];
        self.titleLb.sd_layout
        .leftSpaceToView(self.sologanImgView, 5*2*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
        .rightEqualToView(self.contentView)
        .heightIs(11*2*CA_H_RATIO_WIDTH);
        
        [self.contentView addSubview:self.tagView];
        self.tagView.sd_layout
        .leftEqualToView(self.titleLb)
        .topSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
        .heightIs(11*2*CA_H_RATIO_WIDTH);
        [self.tagView setupAutoWidthWithRightView:self.tagView.tagLb rightMargin:2*2*CA_H_RATIO_WIDTH];
        
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
    self.tagView.hidden = ![NSString isValueableString:model.project_progress];
    self.tagView.tagLb.text = model.project_progress;
    self.importBtn.hidden = ![NSString isValueableString:model.project_status];
    [self.importBtn setTitle:model.project_status forState:UIControlStateNormal];
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

-(CA_MProjectTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MProjectTagView new];
    }
    return _tagView;
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

-(UIImageView *)sologanImgView{
    if (!_sologanImgView) {
        _sologanImgView = [UIImageView new];
        _sologanImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sologanImgView.layer.masksToBounds = YES;
        _sologanImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sologanImgView;
}

@end
