
//
//  CA_MDiscoverCollectionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverCollectionCell.h"
#import "CA_MDiscoverModel.h"

@interface CA_MDiscoverCollectionCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setConstraints];
    }
    return self;
}

-(void)setupUI{
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
}

-(void)setConstraints{
    
    self.titleLb.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .autoHeightRatio(0);

    self.iconImgView.sd_layout
    .topEqualToView(self.contentView)
    .centerXEqualToView(self.contentView)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
}

-(void)setModel:(CA_MModuleModel *)model{
    _model = model;
    
    [_iconImgView setImageURL:[NSURL URLWithString:model.module_logo]];
    
    self.titleLb.text = model.module_name;
}

#pragma mark - getter and setter
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:14];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.layer.cornerRadius = 25*CA_H_RATIO_WIDTH;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.backgroundColor = kColor(@"#f4f4f4");
    }
    return _iconImgView;
}
@end
