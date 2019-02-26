//
//  CA_MDiscoverProjectDetailCorePersonCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailCorePersonCell.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverProjectDetailCorePersonCell ()
@property (nonatomic,strong) UIImageView *sloganImgView;
//@property (nonatomic,strong) ButtonLabel *nameLb;
@property (nonatomic,strong) UILabel *positionLb;
@property (nonatomic,strong) UILabel *introLb;

@end

@implementation CA_MDiscoverProjectDetailCorePersonCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.positionLb];
    [self.contentView addSubview:self.introLb];
    [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
    self.sloganImgView.sd_layout
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.nameLb.sd_layout
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLb setSingleLineAutoResizeWithMaxWidth:(CA_H_SCREEN_WIDTH - (38+10)*2*CA_H_RATIO_WIDTH)];
    
    self.positionLb.sd_layout
    .topSpaceToView(self.nameLb, 2*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.nameLb)
    .autoHeightRatio(0);
    [self.positionLb setSingleLineAutoResizeWithMaxWidth:(CA_H_SCREEN_WIDTH - (38+10)*2*CA_H_RATIO_WIDTH)];
    
    self.introLb.isAttributedContent = YES;
    self.introLb.sd_layout
    .leftEqualToView(self.positionLb)
    .topSpaceToView(self.positionLb, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.introLb setMaxNumberOfLinesToShow:0];
    
    self.lineView.sd_layout
    .leftEqualToView(self.introLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MDiscoverMember_list *)model{
    [super setModel:model];
    
    NSString *imgUrl = [model.member_logo stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self.sloganImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kImage(@"head50")];
    
    self.nameLb.text = model.member_name;
    
    self.positionLb.text = [NSString isValueableString:model.member_position]?model.member_position:@"暂无";
    
    self.introLb.text = [NSString isValueableString:model.member_intro]?model.member_intro:@"暂无";
    
    [self.introLb changeLineSpaceWithSpace:6];
    
    [self setupAutoHeightWithBottomView:self.introLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        _introLb.numberOfLines = 0;
        [_introLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:14];
    }
    return _introLb;
}
-(UILabel *)positionLb{
    if (!_positionLb) {
        _positionLb = [UILabel new];
        [_positionLb configText:@""
                      textColor:CA_H_9GRAYCOLOR
                           font:14];
    }
    return _positionLb;
}
-(ButtonLabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [ButtonLabel new];
        [_nameLb configText:@""
                  textColor:CA_H_TINTCOLOR
                       font:16];
    }
    return _nameLb;
}
-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sloganImgView.layer.cornerRadius = 23*CA_H_RATIO_WIDTH;
        _sloganImgView.layer.masksToBounds = YES;
    }
    return _sloganImgView;
}

@end
