//
//  CA_MProjectProgressCell.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/12.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectProgressModel.h"

/**
 进展记录cell
 */
@interface CA_MProjectRecordCell : UITableViewCell
- (CGFloat)configCell:(CA_MProcedure_logModel*)model
            indexPath:(NSIndexPath*)indexPath
             totalRow:(NSInteger)totalRow;
@end

