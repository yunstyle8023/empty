//
//  CA_HTodoDetailViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HTodoDetailModel.h"

#import "CA_HReplyCell.h"

@interface CA_HTodoDetailViewModel : NSObject

#pragma mark --- 外部实现

@property (nonatomic, copy) void (^onKeyboardBlock)(BOOL isSend);
@property (nonatomic, copy) void (^getDetailBlock)(void);
@property (nonatomic, copy) void (^deleteCommentBlock)(CA_HReplyCell *cell);

@property (nonatomic, copy) void (^borwseFileControllerBlock)(NSNumber *fileId, NSString *fileName, NSString *fileUrl);

@property (nonatomic, copy) void (^buttonViewBlock)(UIView *buttonView);

//滚动到指定评论
@property (nonatomic, strong) NSNumber *commentId;


#pragma mark --- 内部实现

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, copy) UIView *(^titleViewBlock)(void);
@property (nonatomic, copy) UIView *(^bottomViewBlock)(void);
@property (nonatomic, copy) UIView *(^middleViewBlock)(void);


@property (nonatomic, copy) void (^setTitleBlock)(NSString *title, BOOL isDone);
@property (nonatomic, copy) void (^onReplyBlock)(BOOL isAuto);

- (void)setDetailDic:(NSDictionary *)detailDic;
@property (nonatomic, copy) void (^loadDetailBlock)(NSNumber *todoId, NSNumber *objectId, UIView *view);
@property (nonatomic, strong) CA_HTodoDetailModel *model;

- (void)setPeople:(NSArray *)people;

// 阅览文件
@property (nonatomic, copy) void (^borwseFileBlock)(NSNumber *fileId, NSString *fileName, NSString *fileUrl, UIViewController *vc);

- (void)openKeyboard:(CGFloat)height;
- (void)closeKeyboard;

- (void)buttonView:(UIView *)buttonView target:(id)target action:(SEL)action ;

@end
