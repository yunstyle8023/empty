//
//  CA_HAddFileCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HAddFileCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^deleteBlock)(CA_HAddFileCell * deleteCell, BOOL isDelete);

@property (nonatomic, assign) BOOL canTag;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, assign) BOOL noChange;

@end
