//
//  CA_HScheduleListHeaderNode.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//
NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleListHeaderNode : ASCellNode

- (instancetype)initWithStart:(NSNumber *)start end:(NSNumber *)end userIds:(NSArray *)userIds userName:(NSString *)userName;

@end

NS_ASSUME_NONNULL_END
