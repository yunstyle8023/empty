//
//  CA_MSearchDetailInformationBeginCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailInformationBeginCell.h"

@interface CA_MSearchDetailInformationBeginCell()

@end

@implementation CA_MSearchDetailInformationBeginCell

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

@end
