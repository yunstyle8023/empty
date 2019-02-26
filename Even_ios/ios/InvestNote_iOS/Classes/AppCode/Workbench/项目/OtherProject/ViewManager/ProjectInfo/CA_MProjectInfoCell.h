//
//  CA_MProjectInfoCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@protocol CA_MProjectInfoCellDelegate <NSObject>
@optional
//添加输入改变Block回调
-(void)textDidChange:(NSString*)placeHolder content:(NSString*)content;
// 添加到达最大限制Block回调
-(void)textLengthDidMax;
@end

@interface CA_MProjectInfoCell : CA_HBaseTableCell
@property(nonatomic,weak)id<CA_MProjectInfoCellDelegate> delegate;

- (void)configCell:(NSString*)title
       placeHolder:(NSString*)placeHolder
              text:(NSString*)text;
@end

