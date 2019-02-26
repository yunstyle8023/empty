//
//  CA_HSelectMenuView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/30.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HSelectMenuView : UIView

//@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, strong) NSArray * data;

@property (nonatomic, copy) void (^clickBlock)(NSInteger item);
@property (nonatomic, assign) CGFloat maxHeight;

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;

@end
