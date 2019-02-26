//
//  CA_HPrivacyCheck.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HPrivacyCheck.h"
#import <AVFoundation/AVFoundation.h>

@implementation CA_HPrivacyCheck

//麦克风权限（录音等）
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission controller:(UIViewController *)controller {
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                CA_H_DISPATCH_MAIN_THREAD(^{
                    granted ? permissionGranted() : noPermission();
                });
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            //通过授权
            permissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            //不能授权
            NSLog(@"不能完成授权，可能开启了访问限制");
        case AVAuthorizationStatusDenied:{
            //提示跳转到相机设置(这里使用了blockits的弹窗方法）
            
            [controller presentAlertTitle:@"录音授权" message:@"跳转录音授权设置" buttons:@[@"取消",@"设置"] clickBlock:^(UIAlertController *alert, NSInteger index) {
                if (index == 1) {
                    [self requetSettingForAuth];
                }
            }];
        }
            break;
        default:
            break;
    }
}

// 跳转设置
+ (void)requetSettingForAuth {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([ [UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
