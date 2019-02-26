//
//  CA_HCustomAlert.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HCustomAlert : UIView

// 弹框View
+ (CA_HCustomAlert *)alertView:(UIView *)view;
+ (void)hide:(BOOL)animated;

+ (CA_HCustomAlert *)alertView:(UIView *)view superView:(UIView *)superView;
+ (void)hide:(BOOL)animated superView:(UIView *)superView;

@end
