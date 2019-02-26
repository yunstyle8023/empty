//
//  CA_HFolderFileCellViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBrowseFoldersModel.h"

@interface CA_HFolderFileCellViewModel : NSObject

#pragma mark --- 外部实现


#pragma mark --- 内部实现

@property (nonatomic, copy) UIImageView *(^cloudImageViewBlock)(UIView *leftView);

@property (nonatomic, copy) void (^resetViewBlock)(UITableViewCell *cell);

@property (nonatomic, copy) UIView *(^tagViewBlock)(void);
@property (nonatomic, copy) void (^reloadTagsBlock)(NSArray *tags);

@property (nonatomic, copy) UIButton *(^editBlock)(id target, SEL action);

@property (nonatomic, copy) void (^downloadBlock)(CA_HBrowseFoldersModel *model, UIView *contentView);

@end
