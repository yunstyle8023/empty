//
//  CA_HChooseTagMenuViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HChooseTagMenuViewModel : NSObject

#pragma mark --- 外部实现
@property (nonatomic, copy) void (^dismissMenuBlock)(void);
@property (nonatomic, copy) void (^showMassageBlock)(NSString *massage);
@property (nonatomic, copy) void (^addNewTagBlock)(void);
@property (nonatomic, copy) void (^dataCorrectionBlock)(NSArray *tags);// 数据回调
@property (nonatomic, copy) void (^loadMenuBlock)(void);

#pragma mark --- 内部实现
// 创建控件
@property (nonatomic, copy) UIView *(^menuViewBlock)(id target, SEL action, UIView *contentView);
@property (nonatomic, copy) UICollectionView *(^collectionViewBlock)(id delegate);


// 更新数据
@property (nonatomic, copy) void (^requestBlock)(void);
@property (nonatomic, copy) void (^reloadDataBlock)(NSArray *data);
@property (nonatomic, copy) void (^addDataBlock)(NSString *tagStr);
@property (nonatomic, copy) void (^oldTagsBlock)(NSArray *tags);

// Collection
@property (nonatomic, copy) NSInteger (^numberOfItemsBlock)(NSInteger section);
@property (nonatomic, copy) CGSize (^sizeForItemBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^cellForItemBlock)(UICollectionViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic, copy) BOOL (^shouldSelectItemBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^shuoldDoneBlock)(void);

//点击处理
@property (nonatomic, copy) void (^clickBlock)(UIButton *sender);

// 展示
@property (nonatomic, copy) void (^showBlock)(void);

// textField
@property (nonatomic, copy) BOOL (^textFieldShouldChangeBlock)(NSString *text, NSString *string);

@end
