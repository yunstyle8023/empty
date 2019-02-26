//
//  CA_HMultiSelectViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYPhotoBrowseView.h"

@interface CA_HMultiSelectViewModel : NSObject

@property (nonatomic, copy) UIViewController * (^getControllerBlock)(void);
@property (nonatomic, copy) void (^backBlock)(BOOL isNext);
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic, BOOL animated);

@property (nonatomic, assign) NSUInteger maxSelected;

@property (nonatomic, strong) UIButton * titleView;
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * leftBarButtonItem;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * originalButton;


- (void)showPhotoBrowser:(UIView *)view;

@end
