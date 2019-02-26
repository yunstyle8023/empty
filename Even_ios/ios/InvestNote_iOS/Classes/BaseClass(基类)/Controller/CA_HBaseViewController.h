//
//  CA_HBaseViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HBaseViewController : UIViewController

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, assign) BOOL navBarHidden;


/**
 系统更新布局是会调用
 */
- (void)ca_layoutContentView;
- (void)ca_backAction;

/**
 无网络时展示的页面
 */
- (void)showNoNetwork;
/**
 隐藏无网络时展示的页面
 */
- (void)hiddenNoNetwork;
/**
 无网络时重新加载
 */
- (void)reloadData;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (void)resignFirstResponder;
@end
