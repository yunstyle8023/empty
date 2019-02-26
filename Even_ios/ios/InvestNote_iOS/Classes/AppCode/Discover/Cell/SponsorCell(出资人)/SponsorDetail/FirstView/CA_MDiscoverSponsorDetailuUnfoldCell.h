//
//  CA_MDiscoverSponsorDetailuUnfoldCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@class CA_MDiscoverSponsorDetailModel;

@interface CA_MDiscoverSponsorDetailuUnfoldCell : CA_HBaseTableCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) void(^unfoldBlock)(BOOL isUnfold);

-(CGFloat)configCell:(CA_MDiscoverSponsorDetailModel *)model
        indexPath:(NSIndexPath *)indexPath;
@end
