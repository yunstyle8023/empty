//
//  CA_HMineCountCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineCountCell.h"

#import "CA_HMineModel.h"

@interface CA_HMineCountCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CA_HMineCountCell

#pragma mark --- Action

- (void)setModel:(CA_HMineModel *)model {
    [super setModel:model];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.ts_start.longValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.ts_end.longValue];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@", [startDate stringWithFormat:@"MM.dd"], [endDate stringWithFormat:@"MM.dd"]];
    
    self.CountArray = model.personal_count;
}

#pragma mark --- Lazy

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [UILabel new];
        _timeLabel = label;
        
        label.numberOfLines = 1;
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        
        UIView *view = [UIView new];
        view.backgroundColor = CA_H_F8COLOR;
        
        [view addSubview:label];
        label.sd_layout
        .leftSpaceToView(view, 5*CA_H_RATIO_WIDTH)
        .centerYEqualToView(view)
        .autoHeightRatio(0);
        [label setMaxNumberOfLinesToShow:1];
        [label setSingleLineAutoResizeWithMaxWidth:200*CA_H_RATIO_WIDTH];
        
        [self.contentView addSubview:view];
        view.sd_resetLayout
        .heightIs(22*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.textLabel, 10*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.textLabel);
        view.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
        
        [view setupAutoWidthWithRightView:label rightMargin:5*CA_H_RATIO_WIDTH];
        
    }
    return _timeLabel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.textLabel.numberOfLines = 1;
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.sd_resetLayout
    .leftSpaceToView(self.textLabel.superview, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.textLabel.superview, 15*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:80*CA_H_RATIO_WIDTH];
    
    
//    NSArray * points = @[@"{20, 85}",
//                         @"{138, 85}",
//                         @"{256, 85}",
//                         @"{20, 145}",
//                         @"{138, 145}",
//                         @"{256, 145}"];
//    
//    NSMutableArray * textArr = [NSMutableArray arrayWithObjects:
//                                CA_H_LAN(@"新增项目"),
//                                CA_H_LAN(@"新增人脉"),
//                                CA_H_LAN(@"新增出资人"),
//                                CA_H_LAN(@"新增笔记"),
//                                CA_H_LAN(@"完成待办"),
//                                CA_H_LAN(@"共享文件数"),
//                                nil];
//    
//    for (NSString * pointStr in points) {
//        CGPoint point = CGPointFromString(pointStr);
//        UILabel * textLabel = self.labelRegular;
//        textLabel.text = CA_H_LAN(textArr.firstObject);
//        [textArr removeFirstObject];
//        [self.contentView addSubview:textLabel];
//        textLabel.sd_layout
//        .topSpaceToView(self.contentView, point.y*CA_H_RATIO_WIDTH)
//        .leftSpaceToView(self.contentView, point.x*CA_H_RATIO_WIDTH)
//        .autoHeightRatio(0);
//        [textLabel setMaxNumberOfLinesToShow:1];
//        [textLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
//    }
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

- (UILabel *)labelMedium {
    UILabel * label = [UILabel new];
    label.font = CA_H_FONT_PFSC_Medium(18);
    label.textColor = CA_H_4BLACKCOLOR;
    label.numberOfLines = 1;
    return label;
}

- (UILabel *)labelRegular {
    UILabel * label = [UILabel new];
    label.font = CA_H_FONT_PFSC_Regular(12);
    label.textColor = CA_H_9GRAYCOLOR;
    label.numberOfLines = 1;
    return label;
}

- (void)setCountArray:(NSArray<CA_HMineCountModel *> *)countArray {
    NSArray * points = @[@"{20, 57}",
                         @"{138, 57}",
                         @"{256, 57}",
                         @"{20, 117}",
                         @"{138, 117}",
                         @"{256, 117}"];
    
    for (NSInteger i=0; i<points.count; i++) {
        
        UILabel *countLabel = [self.contentView viewWithTag:i+100];
        UILabel *nameLabel = [self.contentView viewWithTag:i+200];
        
        if (i < countArray.count) {
            if (!countLabel) {
                CGPoint point = CGPointFromString(points[i]);
                countLabel = self.labelMedium;
                countLabel.tag = i+100;
                [self.contentView addSubview:countLabel];
                countLabel.sd_layout
                .topSpaceToView(self.contentView, point.y*CA_H_RATIO_WIDTH)
                .leftSpaceToView(self.contentView, point.x*CA_H_RATIO_WIDTH)
                .autoHeightRatio(0);
                [countLabel setMaxNumberOfLinesToShow:1];
                [countLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
            }
            countLabel.text = countArray[i].count.stringValue;
            
            if (!nameLabel) {
                CGPoint point = CGPointFromString(points[i]);
                nameLabel = self.labelRegular;
                nameLabel.tag = i+200;
                [self.contentView addSubview:nameLabel];
                nameLabel.sd_layout
                .topSpaceToView(self.contentView, (point.y+28)*CA_H_RATIO_WIDTH)
                .leftSpaceToView(self.contentView, point.x*CA_H_RATIO_WIDTH)
                .autoHeightRatio(0);
                [nameLabel setMaxNumberOfLinesToShow:1];
                [nameLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
            }
            nameLabel.text = countArray[i].name;
            
        } else {
            countLabel.text = nil;
            nameLabel.text = nil;
        }
        
    }
}

#pragma mark --- Delegate

@end
