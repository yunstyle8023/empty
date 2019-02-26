//
//  CA_HScheduleListVM.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListVM.h"

@implementation CA_HScheduleListVM

#pragma mark --- Action

#pragma mark --- Lazy

- (ASTableNode *)tableNode {
    if (!_tableNode) {
        ASTableNode *tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
        _tableNode = tableNode;
        
        tableNode.contentInset = UIEdgeInsetsMake(0, 0, 70*CA_H_RATIO_WIDTH, 0);
        tableNode.backgroundColor = [UIColor whiteColor];
    }
    return _tableNode;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
