//
//  CA_HNoteInformationViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteInformationViewManager.h"

@implementation CA_HNoteInformationViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UIView *)informationView{
    if (!_informationView) {
        UIView * labelView = [UIView new];
        _informationView = labelView;
        
        labelView.backgroundColor = [UIColor whiteColor];
        
        UIView *line1 = self.labelLine;
        [labelView addSubview:line1];
        line1.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .rightEqualToView(labelView)
        .leftSpaceToView(labelView, 20*CA_H_RATIO_WIDTH)
        .topSpaceToView(labelView, 65*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
        
        UIView *line2 = [self labelLine];
        [labelView addSubview:line2];
        line2.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .rightEqualToView(labelView)
        .leftSpaceToView(labelView, 20*CA_H_RATIO_WIDTH)
        .topSpaceToView(labelView, 220*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
        
        
        UILabel * title = self.labelMedium;
        title.text = CA_H_LAN(@"信息");
        [labelView addSubview:title];
        title.sd_layout
        .topSpaceToView(labelView, 30*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
        .leftSpaceToView(labelView, 20*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [title setMaxNumberOfLinesToShow:1];
        [title setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
        
        NSArray * points = @[@"{20, 86}",
                             @"{130, 86}",
                             @"{20, 153}",
                             @"{130, 153}",
                             @"{20, 241}",
                             @"{20, 305}",
                             @"{20, 369}"];
        
        NSMutableArray * textArr = [NSMutableArray arrayWithObjects:@"字数",@"字符",@"阅读时间",@"段落",@"创建日期",@"修改日期",@"创建地点", nil];
        
        for (NSString * pointStr in points) {
            CGPoint point = CGPointFromString(pointStr);
            UILabel * textLabel = self.labelLight;
            textLabel.text = CA_H_LAN(textArr.firstObject);
            [textArr removeFirstObject];
            [labelView addSubview:textLabel];
            textLabel.sd_layout
            .topSpaceToView(labelView, point.y*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
            .leftSpaceToView(labelView, point.x*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [textLabel setMaxNumberOfLinesToShow:1];
            [textLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
        }
        
    }
    return _informationView;
}


#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)labelLine {
    UIView *label = [UIView new];
    label.backgroundColor = CA_H_BACKCOLOR;
    return label;
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
    label.font = CA_H_FONT_PFSC_Regular(14);
    label.textColor = CA_H_4BLACKCOLOR;
    label.numberOfLines = 1;
    return label;
}

- (UILabel *)labelLight {
    UILabel * label = [UILabel new];
    label.font = CA_H_FONT_PFSC_Light(12);
    label.textColor = CA_H_9GRAYCOLOR;
    label.numberOfLines = 1;
    return label;
}


- (void)setTopStrings:(NSArray<NSString *> *)topStrings {
    NSArray * points = @[
                         @"{20, 108}",
                         @"{130, 108}",
                         @"{20, 175}",
                         @"{130, 175}"
                         ];
    
    for (NSInteger i=0; i<topStrings.count; i++) {
        if (i >= points.count) {
            break;
        }
        
        UILabel *label = [self.informationView viewWithTag:i+100];
        if (!label) {
            CGPoint point = CGPointFromString(points[i]);
            label = self.labelMedium;
            label.tag = i+100;
            [self.informationView addSubview:label];
            label.sd_layout
            .topSpaceToView(self.informationView, point.y*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
            .leftSpaceToView(self.informationView, point.x*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [label setMaxNumberOfLinesToShow:1];
            [label setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
        }
        if (i == 2) {
            label.isAttributedContent = YES;
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            
            NSMutableAttributedString *topString = [[NSMutableAttributedString alloc]initWithString:topStrings[i]];
            topString.font = label.font;
            topString.color = label.textColor;
            
            NSMutableAttributedString *unit = [[NSMutableAttributedString alloc]initWithString:CA_H_LAN(@" 分钟")];
            unit.font = CA_H_FONT_PFSC_Regular(10);
            unit.color = label.textColor;
            
            [text appendAttributedString:topString];
            [text appendAttributedString:unit];
            
            label.attributedText = text;
            
        } else {
            label.text = topStrings[i];
        }
    }
}

- (void)setBottomStrings:(NSArray<NSString *> *)bottomStrings {
    NSArray * points = @[
                         @"{20, 265}",
                         @"{20, 329}",
                         @"{20, 393}"
                         ];
    
    for (NSInteger i=0; i<bottomStrings.count; i++) {
        if (i >= points.count) {
            break;
        }
        
        UILabel *label = [self.informationView viewWithTag:i+200];
        if (!label) {
            CGPoint point = CGPointFromString(points[i]);
            label = self.labelRegular;
            label.tag = i+200;
            [self.informationView addSubview:label];
            label.sd_layout
            .topSpaceToView(self.informationView, point.y*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
            .leftSpaceToView(self.informationView, point.x*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [label setMaxNumberOfLinesToShow:1];
            [label setSingleLineAutoResizeWithMaxWidth:200*CA_H_RATIO_WIDTH];
        }
        label.text = bottomStrings[i];
    }
}

#pragma mark --- Delegate

@end
