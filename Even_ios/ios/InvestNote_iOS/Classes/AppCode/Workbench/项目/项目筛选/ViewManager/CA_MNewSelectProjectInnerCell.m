//
//  CA_MNewSelectProjectInnerCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectInnerCell.h"
#import "CA_MNewSelectProjectConditionsModel.h"

@interface CA_MNewSelectProjectInnerCell ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *selectedImgView;
@end

@implementation CA_MNewSelectProjectInnerCell

-(void)upView{
    [super upView];
    self.contentView.backgroundColor = kColor(@"#F8F8F8");
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.selectedImgView];
    [self setConstrains];
}

-(void)setConstrains{
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    UIImage *image = kImage(@"icons_choose4");
    self.selectedImgView.sd_layout
    .centerYEqualToView(self.titleLb)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
}

-(void)setModel:(CA_MNewSelectProjectConditionsDataListModel *)model{
    [super setModel:model];
    
    self.titleLb.text = model.name;
    
    self.titleLb.textColor = (model.isSelected ? CA_H_TINTCOLOR : CA_H_4BLACKCOLOR);
    
    self.selectedImgView.hidden = !model.isSelected;
    
}

-(UIImageView *)selectedImgView{
    if (!_selectedImgView) {
        _selectedImgView = [UIImageView new];
        _selectedImgView.image = kImage(@"icons_choose4");
    }
    return _selectedImgView;
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

@end
