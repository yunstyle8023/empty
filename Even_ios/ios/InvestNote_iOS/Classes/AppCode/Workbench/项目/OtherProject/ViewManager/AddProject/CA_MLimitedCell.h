//
//  CA_MLimitedCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MTypeModel.h"

@protocol CA_MLimitedCellDelegate <NSObject>
@optional
//添加输入改变Block回调
-(void)textDidChange:(NSString*)content;
@optional
// 添加到达最大限制Block回调
-(void)textLengthDidMax;
@end

@interface CA_MLimitedCell : UITableViewCell
@property (nonatomic,strong) CA_MTypeModel *model;
@property (nonatomic,weak) id<CA_MLimitedCellDelegate> delegate;
@property (nonatomic,assign) NSInteger maxLength;
@end
