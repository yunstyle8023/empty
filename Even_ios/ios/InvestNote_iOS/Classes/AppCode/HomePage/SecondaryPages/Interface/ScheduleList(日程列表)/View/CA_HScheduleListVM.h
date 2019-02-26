//
//  CA_HScheduleListVM.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HScheduleListNullNode.h"
#import "CA_HScheduleListHeaderNode.h"
#import "CA_HScheduleListCellNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface CA_HScheduleListVM : NSObject

@property (nonatomic, strong) ASTableNode *tableNode;

@end

NS_ASSUME_NONNULL_END
