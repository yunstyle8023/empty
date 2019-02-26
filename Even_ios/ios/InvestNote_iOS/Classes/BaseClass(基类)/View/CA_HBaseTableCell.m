//
//  CA_HBaseTableCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@implementation CA_HBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)upView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setModel:(NSObject *)model{
    _model = model;
}

@end
