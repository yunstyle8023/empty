//
//  CA_HProgressHUD.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HProgressHUD : NSObject

+ (MBProgressHUD *)loading:(UIView*)rootView;

+ (MBProgressHUD *)showHud:(UIView*)rootView text:(NSString*)text;//显示HUD
+ (void)hideHud:(UIView*)rootView;
+ (void)hideHud:(UIView*)rootView animated:(BOOL)animated;


+ (void)showHudStr:(NSString *)str rootView:(UIView *)rootView image:(UIImage *)image;//2秒后消隐
//+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView;//成功时，2秒后消隐
//+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView;//失败时，2秒后消隐



+ (MBProgressHUD *)showHud:(NSString*)text;//显示HUD
+ (void)hideHud;

+ (void)showHudStr:(NSString *)str image:(UIImage *)image;//2秒后消隐
+ (void)showHudStr:(NSString*)str;//2秒后消隐
//+ (void)showHudSuccess:(NSString *)success;//成功时，2秒后消隐
//+ (void)showHudFailed:(NSString *)failed;//失败时，2秒后消隐

@end
