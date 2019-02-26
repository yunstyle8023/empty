
//
//  CA_MDiscoverSponsorDetailuUnfoldCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailuUnfoldCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailuUnfoldCell ()
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIButton *unfoldBtn;
@end

@implementation CA_MDiscoverSponsorDetailuUnfoldCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.unfoldBtn];
    [self setConstrains];
}

-(void)setConstrains{
    
    self.detailLb.isAttributedContent = YES;
    self.detailLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
//    self.detailLb.numberOfLines = 0;
//    [self.detailLb setMaxNumberOfLinesToShow:0];
    
    self.unfoldBtn.sd_layout
    .leftEqualToView(self.detailLb)
    .topSpaceToView(self.detailLb, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(54*2*CA_H_RATIO_WIDTH)
    .heightIs(16*2*CA_H_RATIO_WIDTH);
    
}

-(CGFloat)configCell:(CA_MDiscoverSponsorDetailModel *)model
        indexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {//国有背景
        self.detailLb.text = [NSString isValueableString:model.base_info.state_background]?model.base_info.state_background:@"暂无";
        [self.detailLb changeLineSpaceWithSpace:7];
        self.unfoldBtn.hidden = model.base_info.state_background_unfold;
    }else if (indexPath.section == 3) {//描述信息
        self.detailLb.text = [NSString isValueableString:model.base_info.lp_desc]?model.base_info.lp_desc:@"暂无";
        [self.detailLb changeLineSpaceWithSpace:7];
        self.unfoldBtn.hidden = model.base_info.lp_desc_unfold;
    }
    
    CGFloat standardHeight = [self boundingRectWithSize:CGSizeMake(CA_H_SCREEN_WIDTH - 40, CGFLOAT_MAX) WithStr:@"标准高度" andFont:CA_H_FONT_PFSC_Regular(16) andLinespace:7].height;
    CGFloat titleHeight = [self boundingRectWithSize:CGSizeMake(CA_H_SCREEN_WIDTH - 40, CGFLOAT_MAX) WithStr:self.detailLb.text andFont:CA_H_FONT_PFSC_Regular(16) andLinespace:7].height;
    
    if (self.unfoldBtn.isHidden) {
        self.detailLb.numberOfLines = 0;
        [self.detailLb setMaxNumberOfLinesToShow:0];
        return titleHeight + 10*2*CA_H_RATIO_WIDTH;
    }else{
        
        CGFloat maxHeight = standardHeight*4 + 0.1 + 3*7;
        
        self.detailLb.numberOfLines = 4;
//        [self.detailLb setMaxNumberOfLinesToShow:4];
        
        self.detailLb.sd_layout.maxHeightIs(maxHeight);
        
        self.unfoldBtn.hidden = titleHeight < maxHeight;
        
        if (titleHeight >= maxHeight) {
            return maxHeight + 10*2*CA_H_RATIO_WIDTH + 16*2*CA_H_RATIO_WIDTH + 10*2*CA_H_RATIO_WIDTH;
        }else{
            return titleHeight + 10*2*CA_H_RATIO_WIDTH;
        }
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size WithStr:(NSString*)string andFont:(UIFont *)font andLinespace:(CGFloat)space
{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [string boundingRectWithSize:size
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return retSize;
}

-(void)unfoldBtnAction:(UIButton*)sender{
//    sender.selected = !sender.isSelected;
    sender.selected = YES;
    if (self.unfoldBlock) {
        self.unfoldBlock(sender.isSelected);
    }
}

-(UIButton *)unfoldBtn{
    if (!_unfoldBtn) {
        _unfoldBtn = [UIButton new];
        _unfoldBtn.layer.cornerRadius = 8*2*CA_H_RATIO_WIDTH;
        _unfoldBtn.layer.masksToBounds = YES;
        _unfoldBtn.backgroundColor = kColor(@"#F8F8F8");
        [_unfoldBtn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        _unfoldBtn.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        
        [_unfoldBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        [_unfoldBtn setTitle:@"收起全部" forState:UIControlStateSelected];
        
        [_unfoldBtn setImage:kImage(@"icons_more3") forState:UIControlStateNormal];
        [_unfoldBtn setImage:kImage(@"icons_datails7") forState:UIControlStateSelected];
        _unfoldBtn.selected = NO;
        
//        _unfoldBtn.hidden = YES;
        
        _unfoldBtn.titleLabel.sd_resetLayout
        .topSpaceToView(_unfoldBtn, 3*2*CA_H_RATIO_WIDTH)
        .leftSpaceToView(_unfoldBtn, 9*2*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [_unfoldBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:0];
        
        _unfoldBtn.imageView.sd_resetLayout
        .centerYEqualToView(_unfoldBtn.titleLabel)
        .leftSpaceToView(_unfoldBtn.titleLabel, 2*2*CA_H_RATIO_WIDTH)
        .widthIs(6*2*CA_H_RATIO_WIDTH)
        .heightEqualToWidth();
        
        [_unfoldBtn addTarget:self action:@selector(unfoldBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfoldBtn;
}
-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb configText:@""
                    textColor:CA_H_4BLACKCOLOR
                         font:16];
    }
    return _detailLb;
}

@end
