//
//  CA_MProjectProgressStageCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectProgressModel.h"

@interface CA_MProjectProgressStageCell : UITableViewCell
- (CGFloat)configCell:(CA_MProcedure_logModel*)model
            indexPath:(NSIndexPath*)indexPath
             totalRow:(NSInteger)totalRow;
@end
