//
//  CADebugging.h
//  InvestNote_iOSTests
//
//  Created by 韩云智 on 2018/4/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CADebugging : NSObject

+ (CADebugging *)sharedManager;

@property (nonatomic, copy) NSString *api;
- (void)debuggingLog:(NSString *)log;

- (void)show:(UIView *)view;
- (void)hide;

@property (nonatomic, strong) UIView *view;



@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) UITextView *textView;

@end
