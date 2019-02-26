
//
//  CA_MDiscoverProjectDetailProductCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailProductCell.h"
#import "CA_MDiscoverTagView.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailProductCell ()
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CA_MDiscoverTagView *tagView;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MDiscoverProjectDetailProductCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
    
    UIImage *image = kImage(@"icons_datails7");
    self.arrowImgView.sd_layout
    .leftSpaceToView(self.contentView, 13*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.arrowImgView, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 3*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:1];
    
    self.tagView.sd_layout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.titleLb rightMargin:3*2*CA_H_RATIO_WIDTH];
    
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailLb setMaxNumberOfLinesToShow:2];
    
    self.lineView.sd_layout
    .leftEqualToView(self.detailLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MDiscoverProduct_list *)model{
    [super setModel:model];
    
    self.titleLb.text = [NSString isValueableString:model.product_name]?model.product_name:@"暂无";

    self.tagView.hidden = ![NSString isValueableString:model.product_type];
    self.tagView.titleLb.text = model.product_type;
    
    if ([NSString isValueableString:model.product_type]) {
         CGFloat product_typeWidth = [model.product_type widthForFont:CA_H_FONT_PFSC_Regular(12)] + 3*2*CA_H_RATIO_WIDTH*2;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:(CA_H_SCREEN_WIDTH-32*2*CA_H_RATIO_WIDTH)-product_typeWidth-3*2*CA_H_RATIO_WIDTH];
    }else{
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-32*2*CA_H_RATIO_WIDTH];
    }
    
    self.detailLb.text = [NSString isValueableString:model.product_intro]?model.product_intro:@"暂无";
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
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
        _detailLb.numberOfLines = 2;
        [_detailLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _detailLb;
}
-(CA_MDiscoverTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MDiscoverTagView new];
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
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"icons_datails7");
    }
    return _arrowImgView;
}

@end
