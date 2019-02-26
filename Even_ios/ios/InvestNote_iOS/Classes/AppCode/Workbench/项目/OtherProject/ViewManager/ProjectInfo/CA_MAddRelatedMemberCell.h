//
//  CA_MAddRelatedMemberCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@protocol CA_MAddRelatedMemberCellDelegate <NSObject>
@optional
//添加输入改变Block回调
-(void)textDidChange:(NSString*)content;
@optional
// 添加到达最大限制Block回调
-(void)textLengthDidMax;
@end

@interface CA_MAddRelatedMemberCell : CA_HBaseTableCell
@property(nonatomic,weak)id<CA_MAddRelatedMemberCellDelegate> delegate;
-(void)configCell:(NSString*)text placeHolder:(NSString*)placeHolder;
@end
