//
//  CA_HAppDelegate+AppLifeCircle.m
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppDelegate+AppLifeCircle.h"
#import <UMSocialCore/UMSocialCore.h>

#import "NSString+CA_HStringCheck.h"
#import "CA_HScheduleTool.h"

@implementation CA_HAppDelegate (AppLifeCircle)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    //微信
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]) {
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    //分享扩展插件跳转添加文件
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"%@%@",CA_H_UrlSchemes,CA_H_ShareData]]) {
        //        获取共享的UserDefaults
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.chengantech.InvestNoteZGC.Share"];
        
        NSData *data = [userDefaults valueForKey:CA_H_ShareData];
        
        NSString *fileName = [url.absoluteString componentsSeparatedByString:@"____"].lastObject;
        fileName = [fileName stringByRemovingPercentEncoding];
        
        NSLog(@"type:%@\ndataLength:%ld", fileName, (unsigned long)data.length);
        
        
        NSDictionary *dic = @{@"fileName":fileName,
                              @"data":data,
                              @"open_type":@"99"};
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CA_H_ShareDataNotification object:dic];
        return YES;
    }
    
    // h5 跳转笔记详情
    NSArray *urlArray = [url.absoluteString getUrlStringParams];
    NSString *noteStr = [NSString stringWithFormat:@"%@chengan:8888/main", CA_H_UrlSchemes];
    NSString *firstStr = urlArray.firstObject;
    if ((firstStr.length >= noteStr.length) && ([[firstStr substringToIndex:noteStr.length] caseInsensitiveCompare:noteStr] == NSOrderedSame)) {
        
        NSDictionary *params = urlArray.lastObject;
        NSString *open_type = params[@"open_type"];
        if ([open_type integerValue] == 1) {
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CA_H_ShareDataNotification object:params];
        }
        
        return YES;
    }
    
    // 友盟统一返回
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    return result;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [CA_HScheduleTool synchronousEventCalendar];
}

@end
