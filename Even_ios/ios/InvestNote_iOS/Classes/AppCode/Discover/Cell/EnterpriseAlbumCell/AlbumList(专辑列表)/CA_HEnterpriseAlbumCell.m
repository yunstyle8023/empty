//
//  CA_HEnterpriseAlbumCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HEnterpriseAlbumCell.h"

@interface CA_HEnterpriseAlbumCell ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation CA_HEnterpriseAlbumCell

#pragma mark --- Action

- (void)setModel:(NSObject *)model {
    [super setModel:model];
    
    self.logoView.image = [UIImage imageWithColor:[UIColor redColor]];
    
    self.nameLabel.text = arc4random()%2?@"微软加速器-北京公布11期入选创新企业":@"中国靠谱的天使投资机构";
    self.detailLabel.text = @"共收录18家公司";
    self.timeLabel.text = @"2018.04.28";
}

#pragma mark --- Lazy

- (UIImageView *)logoView {
    if (!_logoView) {
        UIImageView *imageView = [UIImageView new];
        _logoView = imageView;
    }
    return _logoView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _nameLabel = label;
        label.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_9GRAYCOLOR];
        _timeLabel = label;
        label.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:CA_H_9GRAYCOLOR];
        _detailLabel = label;
    }
    return _detailLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    UIView *view = self.contentView;
    
    [view addSubview:self.logoView];
    self.logoView.sd_layout
    .widthIs(100*CA_H_RATIO_WIDTH)
    .heightIs(75*CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(view, 11*CA_H_RATIO_WIDTH);
    self.logoView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .topSpaceToView(view, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.logoView, 10*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setMaxNumberOfLinesToShow:2];
    
    [view addSubview:self.detailLabel];
    self.detailLabel.sd_layout
    .leftSpaceToView(self.logoView, 10*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.logoView)
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(160*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.timeLabel];
    self.timeLabel.sd_layout
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.logoView)
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(80*CA_H_RATIO_WIDTH);
    
    [CA_HFoundFactoryPattern lineSpace20:self];
}

#pragma mark --- Delegate

@end
