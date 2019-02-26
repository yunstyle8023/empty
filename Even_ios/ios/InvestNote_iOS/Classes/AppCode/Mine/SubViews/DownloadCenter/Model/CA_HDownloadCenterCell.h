//
//  CA_HDownloadCenterCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HDownloadCenterCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^editBlock)(CA_HBaseTableCell * editCell);

- (void)setColorStr:(NSString *)colorStr;

@end
