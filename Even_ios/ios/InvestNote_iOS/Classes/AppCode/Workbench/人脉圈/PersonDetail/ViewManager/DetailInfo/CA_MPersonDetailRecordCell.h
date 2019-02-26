//
//  CA_MPersonDetailRecordCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"
#import "CA_MPersonDetailModel.h"

@interface CA_MPersonDetailRecordCell : CA_HBaseTableCell
-(CGFloat)configCell:(CA_MJob_experience*)model
        indexPath:(NSIndexPath*)indexPath
         totalRow:(NSInteger)totalRow;
@end
