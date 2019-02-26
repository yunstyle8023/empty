//
//  CA_MProjectDetailHistoryEndCell.m
//  InvestNote_iOS
//
//  Created byyezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailHistoryEndCell.h"

@implementation CA_MProjectDetailHistoryEndCell

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.circleView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
}


@end

