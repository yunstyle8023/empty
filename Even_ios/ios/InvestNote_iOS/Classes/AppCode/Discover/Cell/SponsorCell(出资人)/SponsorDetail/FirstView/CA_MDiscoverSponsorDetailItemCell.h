//
//  CA_MDiscoverSponsorDetailItemCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@class CA_MDiscoverSponsorLp_moudle;

@interface CA_MDiscoverSponsorDetailItemCell : CA_HBaseTableCell
-(CGFloat)configCell:(NSArray *)datas;
@property (nonatomic,copy) void(^pushBlock)(CA_MDiscoverSponsorLp_moudle *model);
@end
