//
//  CA_HAddNoteViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNoteModel.h"
#import "CA_HNoteDetailModel.h"

@interface CA_HAddNoteViewModel : NSObject

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, assign) BOOL isHuman;

- (void)saveNote;//创建
- (void)createNote;//编辑
- (void)setContent:(NSArray<CA_HNoteContentModel *> *)content;

@property (nonatomic, copy) void (^pushToDetailBlock)(NSDictionary *dic);
@property (nonatomic, strong) CA_HNoteDetailModel *model;

@end
