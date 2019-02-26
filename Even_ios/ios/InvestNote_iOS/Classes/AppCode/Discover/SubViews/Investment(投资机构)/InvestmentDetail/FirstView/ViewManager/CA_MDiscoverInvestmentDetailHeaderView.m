//
//  CA_MDiscoverInvestmentDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentDetailHeaderView.h"
#import "CA_MDiscoverInvestmentDetailModel.h"

@interface CA_MDiscoverInvestmentDetailHeaderView ()
@property (nonatomic,strong) UIImageView *sloganImgView;
//@property (nonatomic,strong) UILabel *titleLb;
//@property (nonatomic,strong) UILabel *introLb;
@end

@implementation CA_MDiscoverInvestmentDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstrains];
    }
    return self;
}

-(void)upView{
    self.backgroundColor = CA_H_TINTCOLOR;
//    [self addSubview:self.sloganImgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.introLb];
}

-(void)setConstrains{
    
//    self.sloganImgView.sd_layout
//    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
//    .topSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
//    .widthIs(25*2*CA_H_RATIO_WIDTH)
//    .heightEqualToWidth();
    
    self.titleLb.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
//    .widthIs(CA_H_SCREEN_WIDTH-5*2*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-10*2*2*CA_H_RATIO_WIDTH];
    
    self.introLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
}


-(void)configViewWithModel:(CA_MDiscoverInvestmentDetailModel *)model block:(void (^)(CGFloat))block{
    
//    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.base_info] placeholder:kImage(@"")];
    
    self.titleLb.text = model.base_info.gp_name;
    [self.titleLb sizeToFit];
    
    NSMutableString *str = [NSMutableString string];
    
    if ([NSString isValueableString:model.base_info.found_date]) {
        [str appendString:[NSString stringWithFormat:@"%@ |",model.base_info.found_date]];
    }
    
    if ([NSString isValueableString:model.base_info.area]) {
        [str appendString:[NSString stringWithFormat:@" %@ |",model.base_info.area]];
    }
    
    if ([NSString isValueableString:model.base_info.capital_type]) {
        [str appendString:[NSString stringWithFormat:@" %@ ",model.base_info.capital_type]];
    }
    
    self.introLb.text = str;
    
    CGFloat titleHeight = [model.base_info.gp_name heightForFont:CA_H_FONT_PFSC_Medium(22) width:CA_H_SCREEN_WIDTH-40];
    
    CGFloat introHeight = [self.introLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH-40];
    
    
    CGFloat totalHeight = 5*2*CA_H_RATIO_WIDTH + titleHeight;
    
    if ([NSString isValueableString:str]) {
        totalHeight = totalHeight + 8*2*CA_H_RATIO_WIDTH + introHeight + 10*2*CA_H_RATIO_WIDTH;
    }else {
        totalHeight = totalHeight + 5*2*CA_H_RATIO_WIDTH;
    }
    
    block(totalHeight);
    
//    CGFloat standardHeight = [@"标准高度" heightForFont:CA_H_FONT_PFSC_Regular(14) width:138*2*CA_H_RATIO_WIDTH];
//
//    CGFloat introHeight = [model.base_info.gp_intro heightForFont:CA_H_FONT_PFSC_Regular(14) width:138*2*CA_H_RATIO_WIDTH];
//
//    CGFloat resultHeight = 0.;
//
//    if (introHeight >= standardHeight*2) {
//        resultHeight = 20*2*CA_H_RATIO_WIDTH + standardHeight*2 + 10*2*CA_H_RATIO_WIDTH;
//    }else{
//        resultHeight = 20*2*CA_H_RATIO_WIDTH + standardHeight + 10*2*CA_H_RATIO_WIDTH;
//    }
    
//    block(resultHeight);
}

-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        [_introLb configText:@""
                   textColor:kColor(@"#FFFFFF")
                        font:14];
    }
    return _introLb;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        _titleLb.font = CA_H_FONT_PFSC_Medium(22);
        _titleLb.textColor = kColor(@"#FFFFFF");
        _titleLb.alpha = 0.;
    }
    return _titleLb;
}

-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sloganImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sloganImgView.layer.masksToBounds = YES;
    }
    return _sloganImgView;
}

@end
