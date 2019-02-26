//
//  CA_HAppDelegate+RootController.m
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppDelegate+RootController.h"

#import "CA_MTabBarController.h"

#import "CA_HLoginManager.h"

@implementation CA_HAppDelegate (RootController)

/**
 *  window实例
 */
- (void)setAppWindows{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CA_H_MANAGER.mainWindow = self.window;
    self.window.backgroundColor = [UIColor whiteColor];
}

/**
 *  根视图
 */
- (void)setRootViewController{
    
//    if ([NSString isValueableString:GetToken]) {
//        [CA_HLoginManager loginOrganization:[CA_H_UserDefaults objectForKey:NSLoginAccount] callBack:nil];
////        [CA_H_MANAGER hideLoginWindow:YES];
//    }else{
//        [CA_H_MANAGER showLoginWindow:YES];
//    }
    
    if (![NSString isValueableString:GetToken] ||
        ![CA_H_MANAGER isBingdPhoneNumber]) {
        [CA_H_MANAGER showLoginWindow:YES];
    }
    
    self.window.rootViewController = [CA_MTabBarController new];
}

@end
