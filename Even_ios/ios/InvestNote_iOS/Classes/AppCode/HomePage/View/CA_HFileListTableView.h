//
//  CA_HFileListTableView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_HBrowseFoldersModel.h"

typedef enum : NSUInteger {
    CA_HFileSearchTypeNone = 0,
    CA_HFileSearchTypeButton,
    CA_HFileSearchTypeScreening,
} CA_HFileSearchType;

@interface CA_HFileListTableView : UITableView

// 跳转
@property (nonatomic, copy) void (^pushBlock)(NSIndexPath *indexPath);

@property (nonatomic, strong) NSMutableArray *uploads;
@property (nonatomic, strong) NSMutableArray<CA_HBrowseFoldersModel *> * data;
@property (nonatomic, strong) NSMutableArray<CA_HBrowseFoldersModel *> * files;
@property (nonatomic, strong) NSMutableArray<CA_HBrowseFoldersModel *> * folders;

@property (nonatomic, assign) CA_HFileSearchType searchType;

@property (nonatomic, strong) void (^scrollBlock)(UIScrollView *scrollView);

/**
 设置空页面

 @param title 展示文字
 @param buttonTitle 按钮展示文字
 @param top 上边距
 @param block 按钮事件回调
 @param imageName 展示图片名
 */
- (void)nullTitle:(NSString *)title
      buttonTitle:(NSString *)buttonTitle
              top:(CGFloat)top
         onButton:(void(^)(void))block
        imageName:(NSString *)imageName;

@property (nonatomic, copy) void (^editBlock)(UITableViewCell * editCell);

@end
