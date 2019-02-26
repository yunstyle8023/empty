//
//  CA_HTodoFileCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/14.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HTodoFileCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^deleteBlock)(CA_HTodoFileCell * deleteCell);


@end
