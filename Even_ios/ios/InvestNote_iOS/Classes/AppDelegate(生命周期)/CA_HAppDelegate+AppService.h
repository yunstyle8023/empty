//
//  CA_HAppDelegate+AppService.h
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppDelegate.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <WXApi.h>

@interface CA_HAppDelegate (AppService)

/**
 设置bugly
 */
- (void)bugs;
/**
 设置自动管理键盘
 */
- (void)setKeyBoard;

/**
 设置友盟
 */
- (void)setUmSocial;
/**
 设置百度云推送
 */
- (void)setBPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

- (void)setApiKey;

@end
