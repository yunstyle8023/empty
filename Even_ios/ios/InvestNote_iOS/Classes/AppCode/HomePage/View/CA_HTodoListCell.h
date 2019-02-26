//
//  CA_HTodoListCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

typedef enum : NSUInteger {
    CA_H_TodoCellTypeContinue = 0,
    CA_H_TodoCellTypeDone
} CA_H_TodoCellType;

@interface CA_HTodoListCell : CA_HBaseTableCell

@property (nonatomic, assign) CA_H_TodoCellType type;

@property (nonatomic, copy) void (^clickBlock)(CA_HTodoListCell *clickCell);

@end
