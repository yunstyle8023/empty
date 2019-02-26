//
//  CA_HAddNoteManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNoteModel.h"

#import "CA_HAddFileModel.h"

#import "CA_HUpdateFileManager.h"

@interface CA_HAddNoteManager : NSObject

@property (nonatomic, copy) void (^recordStopBlock)(void);

@property (nonatomic, copy) void (^clickBlock)(CA_HAddNoteManager *clickModel);


@property (nonatomic, strong) CA_HUpdateFileManager *updateFileManager;
@property (nonatomic, strong) CA_HAddFileModel *addFileModel;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) CA_HNoteContentModel *contentModel;

@property (nonatomic, copy) CA_HAddNoteManager *(^deleteMe)(void);
@property (nonatomic, copy) CA_HAddNoteManager *(^stop)(void);



@property (nonatomic, copy) CA_HAddNoteManager *(^begin)(YYTextView *textView);
@property (nonatomic, copy) CA_HAddNoteManager *(^model)(CA_HNoteContentModel *model);
@property (nonatomic, copy) CA_HAddNoteManager *(^contentArray)(NSMutableArray *contentArray);
@property (nonatomic, copy) CA_HAddNoteManager *(^showDelete)(BOOL showDelete);
@property (nonatomic, copy) CA_HAddNoteManager *(^end)(BOOL isEdit);

- (void)onDeleteButton:(UIButton *)sender;

@end
