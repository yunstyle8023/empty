//
//  CA_MDiscoverInvestmentFoundsCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsCell.h"

@interface CA_MDiscoverInvestmentFoundsCell : CA_MDiscoverInvestmentManageFoundsCell
@property (nonatomic,copy) void(^didSelectItem)(NSInteger item);
@end
