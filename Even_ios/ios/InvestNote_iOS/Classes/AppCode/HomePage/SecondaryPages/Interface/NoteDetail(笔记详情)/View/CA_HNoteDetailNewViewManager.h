//
//  CA_HNoteDetailNewViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNoteDetailModel.h"
#import "YYPhotoBrowseView.h"//图片预览

#import "CA_HReplyCell.h"//评论

@interface CA_HNoteDetailNewViewManager : NSObject


// Nav
- (UIBarButtonItem *)rightBarButton:(id)target action:(SEL)action;

// Table
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewHeaderFooterView *commentHeader;

- (void)reloadCellsData:(CA_HNoteDetailModel *)model;
- (void)commentCellHeight:(CA_HTodoDetailCommentModel *)model;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model;

// 笔记内容预览
@property (nonatomic, strong) NSMutableArray<YYPhotoGroupItem *> *photoGroupItems;

// 底部按钮
@property (nonatomic, strong) UIView *bottomView;
- (void)bottomButtons:(NSArray<NSString *> *)privilege target:(id)target action:(SEL)action;

// 评论
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *remindButton;
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) CALayer *backLayer;
@property (nonatomic, strong) CATextLayer *holderLayer;
@property (nonatomic, assign) CGFloat replyHeight;

- (void)setPeople:(NSArray *)people;
- (void)onReplyButton;
- (void)keyboardFrame:(CGRect)frame isShow:(BOOL)isShow;

@end
