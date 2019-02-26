//
//  CA_HAppDelegate.m
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppDelegate.h"

//扩展
#import "CA_HAppDelegate+AppService.h"
#import "CA_HAppDelegate+AppLifeCircle.h"
#import "CA_HAppDelegate+RootController.h"

@interface CA_HAppDelegate()

@end

@implementation CA_HAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CA_H_MANAGER.xheight = rectStatus.size.height-20;
    
    [self setApiKey];

    //腾讯bugly
    [self bugs];
    // 键盘
    [self setKeyBoard];
    // 友盟
    [self setUmSocial];
    // 百度云推送
    [self setBPush:application launchOptions:launchOptions];
    
    [self setAppWindows];
    
    [self setRootViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
