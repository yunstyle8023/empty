//
//  CA_MProjectTagCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@protocol CA_MProjectTagCellDelegate <NSObject>
@optional
-(void)delTag:(NSInteger)index;
-(void)addTag;
@end

@interface CA_MProjectTagCell : CA_HBaseTableCell
@property(nonatomic,weak)id<CA_MProjectTagCellDelegate> delegate;
- (CGFloat)configCell:(NSString*)title tags:(NSArray*)datas;
@end

