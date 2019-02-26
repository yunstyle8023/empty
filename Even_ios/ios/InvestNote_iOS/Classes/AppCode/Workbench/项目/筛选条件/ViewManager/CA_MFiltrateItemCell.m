//
//  CA_MFiltrateItemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemCell.h"
#import "CA_HBaseModel.h"

@interface CA_MFiltrateItemCell ()

@property (nonatomic,strong) UILabel *titleLb;

@end

@implementation CA_MFiltrateItemCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    
}

-(void)setModel:(CA_HBaseModel *)model{
    [super setModel:model];
    
    self.titleLb.text = [model valueForKey:self.keyName];
    
    BOOL isSelectd = [[model valueForKey:@"selected"] intValue] == 1 ? YES : NO;

    self.titleLb.textColor = isSelectd?CA_H_TINTCOLOR:CA_H_4BLACKCOLOR;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

@end
