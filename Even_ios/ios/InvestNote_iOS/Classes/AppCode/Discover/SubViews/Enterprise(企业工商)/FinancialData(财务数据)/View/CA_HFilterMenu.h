//
//  CA_HFilterMenu.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HFilterMenu : UIView

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, copy) NSString *selectStr;

@property (nonatomic, copy) void (^clickBlock)(NSInteger item);
@property (nonatomic, assign) CGFloat maxHeight;

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;

@end
