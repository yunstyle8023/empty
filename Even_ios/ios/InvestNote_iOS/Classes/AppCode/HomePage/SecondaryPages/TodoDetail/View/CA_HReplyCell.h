//
//  CA_HReplyCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_HReplyCell : CA_HBaseTableCell

@property (nonatomic, copy) void (^onClickBlock)(CA_HReplyCell *clickCell, BOOL isMine);

@end
