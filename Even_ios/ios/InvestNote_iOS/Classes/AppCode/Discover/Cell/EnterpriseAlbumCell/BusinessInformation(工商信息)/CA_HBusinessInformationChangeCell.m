//
//  CA_HBusinessInformationChangeCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationChangeCell.h"

#import "CA_HBusinessInformationModel.h"

@interface CA_HBusinessInformationChangeCell ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *beforeLabel;
@property (nonatomic, strong) UILabel *afterLabel;

@end

@implementation CA_HBusinessInformationChangeCell

#pragma mark --- Action

- (void)setModel:(CA_HBusinessInformationContentModel *)model {
    [super setModel:model];
    
    self.countLabel.text = model.countStr;
    self.titleLabel.text = model.item_name;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.change_date.doubleValue];
//    self.dateLabel.text = [date stringWithFormat:@"yyyy.MM.dd"];
    self.dateLabel.text = model.change_date;
    {
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendString:model.before_change];
        text.lineSpacing = 6*CA_H_RATIO_WIDTH;
        self.beforeLabel.attributedText = text;
        [self.beforeLabel sizeToFit];
    }
    
    {
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendString:model.after_change];
        text.lineSpacing = 6*CA_H_RATIO_WIDTH;
        self.afterLabel.attributedText = text;
        [self.afterLabel sizeToFit];
    }
}

#pragma mark --- Lazy

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Medium(16) color:CA_H_TINTCOLOR];
        _countLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        _titleLabel = label;
        
        label.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _dateLabel = label;
        
        label.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UILabel *)beforeLabel {
    if (!_beforeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        _beforeLabel = label;
        
        label.numberOfLines = 0;
        label.isAttributedContent = YES;
    }
    return _beforeLabel;
}

- (UILabel *)afterLabel {
    if (!_afterLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
        _afterLabel = label;
        
        label.numberOfLines = 0;
        label.isAttributedContent = YES;
    }
    return _afterLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = CA_H_F8COLOR;
    
    UIView *countView = [UIView new];
    countView.backgroundColor = [UIColor whiteColor];
    [countView addSubview:self.countLabel];
    self.countLabel.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [backView addSubview:countView];
    [backView addSubview:self.titleLabel];
    [backView addSubview:self.dateLabel];
    
    countView.sd_layout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .leftSpaceToView(backView, 2*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 2*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(backView, 2*CA_H_RATIO_WIDTH);
    countView.sd_cornerRadius = @(5*CA_H_RATIO_WIDTH);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(backView, 42*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 6*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:203*CA_H_RATIO_WIDTH];
    
    self.dateLabel.sd_layout
    .widthIs(120*CA_H_RATIO_WIDTH)
    .heightIs(22*CA_H_RATIO_WIDTH)
    .rightSpaceToView(backView, 10*CA_H_RATIO_WIDTH)
    .centerYEqualToView(backView);
    
    
    [self.contentView addSubview:backView];
    backView.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
    [backView setupAutoHeightWithBottomView:self.titleLabel bottomMargin:6*CA_H_RATIO_WIDTH];
    
    
    UILabel *label0 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
    [self.contentView addSubview:label0];
    label0.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(60*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 63*CA_H_RATIO_WIDTH)
    .topSpaceToView(backView, 20*CA_H_RATIO_WIDTH);
    label0.text = @"变更前";
    
    [self.contentView addSubview:self.beforeLabel];
    self.beforeLabel.sd_layout
    .minWidthIs(292*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 63*CA_H_RATIO_WIDTH)
    .topSpaceToView(label0, 10*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.beforeLabel setSingleLineAutoResizeWithMaxWidth:292*CA_H_RATIO_WIDTH];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .leftSpaceToView(self.contentView, 63*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.beforeLabel, 11*CA_H_RATIO_WIDTH);
    
    
    UILabel *label1 = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
    [self.contentView addSubview:label1];
    label1.sd_layout
    .heightIs(22*CA_H_RATIO_WIDTH)
    .widthIs(60*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 63*CA_H_RATIO_WIDTH)
    .topSpaceToView(line, 10*CA_H_RATIO_WIDTH);
    label1.text = @"变更后";
    
    [self.contentView addSubview:self.afterLabel];
    self.afterLabel.sd_layout
    .minWidthIs(292*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 63*CA_H_RATIO_WIDTH)
    .topSpaceToView(label1, 10*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.afterLabel setSingleLineAutoResizeWithMaxWidth:292*CA_H_RATIO_WIDTH];
    
    
    [self setupAutoHeightWithBottomView:self.afterLabel bottomMargin:21*CA_H_RATIO_WIDTH];
}

#pragma mark --- Delegate

@end
