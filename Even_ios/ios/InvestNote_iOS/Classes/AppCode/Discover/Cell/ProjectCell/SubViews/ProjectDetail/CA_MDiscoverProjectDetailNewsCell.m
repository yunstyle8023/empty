//
//  CA_MDiscoverProjectDetailNewsCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailNewsCell ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *sourceLb;
@end

@implementation CA_MDiscoverProjectDetailNewsCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.sourceLb];
     [self.contentView addSubview:self.lineView];
    [self setConstraints];
}

-(void)setConstraints{
    
    self.titleLb.isAttributedContent = YES;
    self.titleLb.sd_layout
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH*2)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:2];
    
    self.timeLb.sd_layout
    .topSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.titleLb)
    .autoHeightRatio(0);
    [self.timeLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.sourceLb.sd_layout
    .centerYEqualToView(self.timeLb)
    .leftSpaceToView(self.timeLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.sourceLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.lineView.sd_layout
    .leftEqualToView(self.timeLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MDiscoverNews_list *)model{
    [super setModel:model];
    
//    model.news_title = @"为手机配备虹膜识别功能，聚虹光电认为移动支付是杀手级应用场景为手机配备虹膜识别功能，聚虹光电认为移动支付是杀手级应用场景为手机配备虹膜识别功能，聚虹光电认为移动支付是杀手级应用场景";
    
    self.titleLb.text = model.news_title;
//    [self.titleLb changeLineSpaceWithSpace:6];

    NSDate *news_publish_date = [NSDate dateWithTimeIntervalSince1970:model.news_publish_date.longValue];
    self.timeLb.text = [news_publish_date stringWithFormat:@"yyyy.MM.dd"];
    self.sourceLb.text = [NSString stringWithFormat:@"来自: %@",[NSString isValueableString:model.news_source]?model.news_source:@"暂无"];
    
    [self setupAutoHeightWithBottomView:self.sourceLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UILabel *)sourceLb{
    if (!_sourceLb) {
        _sourceLb = [UILabel new];
        [_sourceLb configText:@""
                  textColor:kColor(@"#AAAAAA")
                       font:14];
    }
    return _sourceLb;
}
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                    textColor:kColor(@"#AAAAAA")
                         font:14];
    }
    return _timeLb;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
//        _titleLb.numberOfLines = 2;
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}
@end
