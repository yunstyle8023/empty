//
//  CA_HNoteDetailModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNoteDetailModel.h"
#import "CA_MProjectModel.h"

@interface CA_HNoteDetailModelManager : NSObject

//滚动到指定评论
@property (nonatomic, strong) NSNumber *commentId;

@property (nonatomic, strong) CA_HNoteDetailModel *model;

- (void)commentContent;

@property (nonatomic, copy) void (^loadDataBlock)(void);

- (void)requestNote:(NSNumber *)noteId view:(UIView *)view;
- (void)setDetailDic:(NSDictionary *)detailDic;

//分享
- (void)share;
@property (nonatomic, copy) void (^shareLongBlock)(void);

@property (nonatomic, assign) BOOL statusBarHidden;

//更多
@property (nonatomic, strong) NSArray *actionSheets;
- (void)setOnActionSheet:(NSInteger)onActionSheetl;
@property (nonatomic, copy) void (^gotoProjectDetailBlock)(void);
@property (nonatomic, copy) void (^moveBlock)(void);
- (void)doneMoveType:(NSString *)objectType model:(CA_MProjectModel *)model doneBlock:(void(^)(void))doneBlock;
@property (nonatomic, copy) void (^editBlock)(void);
- (void)deleteNote;
@property (nonatomic, copy) void (^deleteNoteBlock)(void);

//评论
- (void)addComment:(NSString *)text;
@property (nonatomic, copy) void (^addCommentBlock)(void);
- (void)deleteComment:(CA_HTodoDetailCommentModel *)model indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, copy) void (^deleteCommentBlock)(NSIndexPath *indexPath);

@end
