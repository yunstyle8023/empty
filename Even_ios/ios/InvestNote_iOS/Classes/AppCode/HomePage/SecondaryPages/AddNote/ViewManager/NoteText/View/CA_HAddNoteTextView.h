//
//  CA_HAddNoteTextView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CA_HAddNoteTextViewModel.h"
#import "YYPhotoBrowseView.h"

@interface CA_HAddNoteTextView : UIView

+ (instancetype)newWithHuman:(BOOL)ishuman;

@property (nonatomic, strong) YYTextView *titleTextView;
@property (nonatomic, strong) YYTextView *contentTextView;

@property (nonatomic, strong) CA_HAddNoteTextViewModel *viewModel;

@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@property (nonatomic, copy) void (^textViewDidChange)(NSString *title, NSString *content);

//录音播放
@property (nonatomic, copy) void (^playRecord)(NSNumber *fileId, NSString *fileName, NSString *fileUrl);

//预览文件
typedef void (^ReturnBlock)(NSNumber *fileId, NSString *fileName, NSString *fileUrl);
@property (nonatomic, copy) ReturnBlock (^browseDocument)(BOOL isFinish);

//浏览图片
@property (nonatomic, copy) void (^photoBrowse)(NSArray *items, UIImageView *imageView);
@property (nonatomic, copy) void (^selectImage)(NSInteger item);

@property (nonatomic, copy) NSString *tagText;
- (void)setTagText:(NSString *)tagText;

@end
