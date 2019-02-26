
//
//  CA_MNewProjectAlreadyCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectAlreadyCollectionViewCell.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectAlreadyCollectionViewCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MNewProjectAlreadyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.bgView];
        self.bgView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        [self.contentView addSubview:self.titleLb];
        self.titleLb.sd_layout
        .leftSpaceToView(self.contentView, 3*2*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 3*2*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView)
        .heightIs(9*2*CA_H_RATIO_WIDTH);
    }
    return self;
}

-(void)setModel:(CA_MProjectRisk_Tag_ListModel *)model{
    _model = model;
    self.bgView.backgroundColor = kColor(model.tag_color);
    self.titleLb.text = model.tag_name;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:[UIColor whiteColor]
                        font:12];
    }
    return _titleLb;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 1*2*CA_H_RATIO_WIDTH;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
