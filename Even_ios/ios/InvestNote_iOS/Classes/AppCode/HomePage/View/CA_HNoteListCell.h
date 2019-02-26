//
//  CA_HNoteListCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/25.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

#define CA_H_EDIT_IMAGES @[ @"move_icon",\
                            @"share_icon",\
                            @"delete_icon"]

@interface CA_HNoteListCell : CA_HBaseTableCell

@property (nonatomic, assign) BOOL isProject;
@property (nonatomic, assign) BOOL isHuman;

/**
 侧滑按钮布局修改方法

 @param button 要修改的button
 @param title 展示文字
 @param imageName 展示图片
 */
+ (void)customButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName;

@end
