//
//  CA_HEditMenuView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HEditMenuView : UIView

@property (nonatomic, strong) NSArray * data;

@property (nonatomic, copy) void (^clickBlock)(NSInteger item);

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;

@property (nonatomic, strong) UIButton * cancelButton;

@end
