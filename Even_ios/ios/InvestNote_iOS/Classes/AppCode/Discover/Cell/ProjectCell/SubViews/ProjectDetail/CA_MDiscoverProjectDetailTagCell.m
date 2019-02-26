
//
//  CA_MDiscoverProjectDetailTagCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailTagCell.h"
#import "CA_MDiscoverProjectDetailTagModel.h"
#import "CA_MDiscoverTagView.h"

@interface CA_MDiscoverProjectDetailTagCell ()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) CA_MDiscoverTagView *tagView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MDiscoverProjectDetailTagCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self setConstraints];
}

-(void)setConstraints{

    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
    self.sloganImgView.sd_layout
    .leftEqualToView(self.lineView)
    .topSpaceToView(self.lineView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sloganImgView)
    .autoHeightRatio(0);
//    [self.titleLb setSingleLineAutoResizeWithMaxWidth:135];
    [self.titleLb setMaxNumberOfLinesToShow:1];
    
    self.tagView.sd_resetLayout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(20*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.titleLb rightMargin:6];
    
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailLb setMaxNumberOfLinesToShow:1];
}

-(void)setModel:(CA_MDiscoverProjectDetailTagModel *)model{
    [super setModel:model];
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    self.tagView.titleLb.text = model.invest_stage;
    
    if ([NSString isValueableString:model.invest_stage]) {
        self.tagView.hidden = NO;
        CGFloat margin = 4*2*CA_H_RATIO_WIDTH;
        CGFloat invest_stageWidth = [model.invest_stage widthForFont:CA_H_FONT_PFSC_Regular(12)]+margin*2;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-38*2*CA_H_RATIO_WIDTH-invest_stageWidth-5*2*CA_H_RATIO_WIDTH-10*2*CA_H_RATIO_WIDTH];
    }else{
        self.tagView.hidden = YES;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-38*2*CA_H_RATIO_WIDTH-10*2*CA_H_RATIO_WIDTH];
    }
    
    NSString *brief_intro = model.brief_intro;
    brief_intro = [brief_intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    brief_intro = [brief_intro stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    brief_intro = [brief_intro stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    self.detailLb.text = [NSString isValueableString:brief_intro] ? brief_intro : @"暂无";
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.numberOfLines = 1;
        [_detailLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _detailLb;
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
-(CA_MDiscoverTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MDiscoverTagView new];
    }
    return _tagView;
}
-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.layer.cornerRadius = 2;
        _sloganImgView.layer.masksToBounds = YES;
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sloganImgView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

@end
