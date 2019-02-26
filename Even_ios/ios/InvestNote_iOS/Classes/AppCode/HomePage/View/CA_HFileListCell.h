//
//  CA_HFileListCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HFileListCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^editBlock)(UITableViewCell * editCell);

@end
