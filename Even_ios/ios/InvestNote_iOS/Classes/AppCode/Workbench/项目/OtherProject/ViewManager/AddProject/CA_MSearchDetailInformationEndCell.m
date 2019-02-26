//
//  CA_MSearchDetailInformationEndCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailInformationEndCell.h"

@interface CA_MSearchDetailInformationEndCell()

@end

@implementation CA_MSearchDetailInformationEndCell

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.circleView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];

}

@end
