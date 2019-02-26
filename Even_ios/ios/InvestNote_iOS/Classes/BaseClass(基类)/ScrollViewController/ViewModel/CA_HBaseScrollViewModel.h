//
//  CA_HBaseScrollViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBaseScrollView.h"

@interface CA_HBaseScrollViewModel : NSObject

#pragma mark --- 外部实现

@property (nonatomic, copy) void (^scrollBlock)(NSInteger index);

#pragma mark --- 内部实现

@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, copy) CA_HBaseScrollView *(^scrollViewBlcok)(id delegate);
@property (nonatomic, copy) UIView *(^buttonViewBlock)(NSArray *titles, UIScrollView *superView, UIFont *font, UIColor *normalColor, UIColor *selectColor);

@property (nonatomic, copy) void (^scrollViewDidScrollBlock)(UIScrollView *scrollView);

@end
