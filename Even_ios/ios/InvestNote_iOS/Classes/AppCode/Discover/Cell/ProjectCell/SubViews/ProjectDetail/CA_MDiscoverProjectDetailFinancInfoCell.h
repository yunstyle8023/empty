//
//  CA_MDiscoverProjectDetailFinancInfoCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@class CA_MDiscoverGp_list;

@interface CA_MDiscoverProjectDetailFinancInfoCell : CA_HBaseTableCell
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) void(^pushBlock)(NSIndexPath *indexPath,CA_MDiscoverGp_list *model);
@end
