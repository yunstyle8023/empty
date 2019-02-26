//
//  CA_HPrivacyCheck.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HPrivacyCheck : NSObject

//麦克风权限（录音等）
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission controller:(UIViewController *)controller;

@end
