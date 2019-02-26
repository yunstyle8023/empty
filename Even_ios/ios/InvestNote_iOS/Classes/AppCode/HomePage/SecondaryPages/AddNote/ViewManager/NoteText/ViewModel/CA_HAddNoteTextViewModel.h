//
//  CA_HAddNoteTextViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNoteModel.h"
#import "CA_HAddNoteManager.h"
#import "CA_HMoveListViewController.h"

#import "CA_HNoteDetailModel.h"
#import "CA_HNoteUploadManager.h"

@interface CA_HAddNoteTextViewModel : NSObject

@property (nonatomic, assign) BOOL ishuman;

@property (nonatomic, copy) YYTextView *(^titleTextView)(id delegate);

@property (nonatomic, copy) YYTextView *(^contentTextView)(id delegate, SEL action);

@property (nonatomic, copy) CA_HAddNoteTextViewModel *(^tagLabel)(NSString *tagText, UIView *superView);

@property (nonatomic, copy) NSUInteger (^indexText)(NSString *text, NSUInteger toIndex);
@property (nonatomic, copy) CA_HAddNoteTextViewModel *(^deleteText)(YYTextView *textView, NSString *text, NSRange range);

@property (nonatomic, strong) CA_HNoteDetailModel *model;
@property (nonatomic, strong) NSArray<CA_HNoteContentModel *> *saveContent;
@property (nonatomic, copy) YYTextView *(^toModel)(CA_HNoteDetailModel *model);

@property (nonatomic, strong) NSMutableArray *contentArray;


// 录音
@property (nonatomic, strong) CA_HAddNoteManager *recordManager;
@property (nonatomic, copy) CA_HAddNoteManager *(^addRecord)(BOOL isPlay);

// 文件
@property (nonatomic, copy) CA_HAddNoteManager *(^addFile)(NSString *fileName);

// 照片
@property (nonatomic, copy) CA_HAddNoteManager *(^addImage)(UIImage *image);
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) void (^selectMenuBlock)(NSInteger item);

@property (nonatomic, copy) void (^clickBlock)(CA_HAddNoteManager *clickManager);


@property (nonatomic, assign) BOOL isProject;
@property (nonatomic, strong) CA_MProjectModel *projectModel;
@property (nonatomic, strong) CA_HNoteTypeModel *typeModel;

@property (nonatomic, strong) CA_HNoteUploadManager *uploadManager;

@end
