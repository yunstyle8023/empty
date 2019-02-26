//
//  CA_MPersonIntroduceCell.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@protocol CA_MPersonIntroduceCellDelegate <NSObject>
@optional
//添加输入改变Block回调
-(void)textDidChange:(NSString*)content;
@optional
// 添加到达最大限制Block回调
-(void)textLengthDidMax;
@end

@interface CA_MPersonIntroduceCell : CA_HBaseTableCell
@property (nonatomic,weak) id<CA_MPersonIntroduceCellDelegate> delegate;
-(void)configCell:(NSString*)title
             text:(NSString*)text
      placeHolder:(NSString*)placeHolder;
@end
