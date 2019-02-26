//
//  CA_HScreeningCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/26.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HScreeningCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^doneBlock)(void);

@end
