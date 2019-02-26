//
//  CA_HAddTodoCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

typedef enum : NSUInteger {
    CA_H_AddTodoTypeProject = 0,
    CA_H_AddTodoTypePeople,
    CA_H_AddTodoTypeDate,
    CA_H_AddTodoTypeRemind,
    CA_H_AddTodoTypeFirst,
    CA_H_AddTodoTypeRemark,
    CA_H_AddTodoTypeFile
} CA_H_AddTodoType;

@interface CA_HAddTodoCell : CA_HBaseTableCell

@property (nonatomic, assign) CA_H_AddTodoType type;

@end
