//
//  CA_HGeneralSituationHeader.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HGeneralSituationHeader.h"

@interface CA_HGeneralSituationHeader ()

@end

@implementation CA_HGeneralSituationHeader

#pragma mark --- Action

#pragma mark --- Lazy

- (UIView *)line {
    if (!_line) {
        UIView *line = [UIView new];
        _line = line;
        
        line.backgroundColor = CA_H_BACKCOLOR;

        [self addSubview:line];
        line.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .topEqualToView(self)
        .rightEqualToView(self)
        .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
    }
    return _line;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Medium(18) color:CA_H_4BLACKCOLOR];
        _label = label;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    }
    return _label;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
