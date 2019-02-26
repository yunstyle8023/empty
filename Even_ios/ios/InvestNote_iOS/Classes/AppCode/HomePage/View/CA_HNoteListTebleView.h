//
//  CA_HNoteListTebleView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/23.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CA_HListNoteModel.h"

@interface CA_HNoteListTebleView : UITableView

// 跳转
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@property (nonatomic, strong) CA_HListNoteModel *listNoteModel;

@property (nonatomic, strong) void (^scrollBlock)(UIScrollView *scrollView);

/**
 设置头视图

 @return 头视图
 */
- (UIView *)headerView;

+ (instancetype)newWithProjectId:(NSNumber *)projectId objectType:(NSString *)objectType ;

@end
