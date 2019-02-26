//
//  CA_HLongViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/18.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HAddNoteTextView.h"
#import "CA_HNoteDetailModel.h"
#import "CA_HNoteDetailAttachCell.h"

typedef enum : NSUInteger {
    CA_HLongTypeDefault = 0,
    CA_HLongTypeFound,
} CA_HLongType;

@interface CA_HLongViewModel : NSObject


@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) UIView *(^bottomViewBlock)(id target, SEL action);
@property (nonatomic, copy) UIScrollView *(^scrollViewBlock)(BOOL isImage);

@property (nonatomic, strong) UIImage * image;


//笔记
- (void)loadImage:(NSNumber *)noteId success:(void(^)(UIImageView *imageView))success failed:(void(^)(void))failed;
- (void)cancelImageRequest;
//项目
- (UIImageView *)imageViewWithImage:(UIImage *)image type:(CA_HLongType)type;
@property (nonatomic, assign) CGSize contentSize;

//新版生成长图
@property (nonatomic, strong) CA_HNoteDetailModel *model;
- (void)setDetailDic:(NSDictionary *)detailDic;
@property (nonatomic, strong) UITableView *tableView;
- (void)reloadCellsData:(CA_HNoteDetailModel *)model;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model;


@end
