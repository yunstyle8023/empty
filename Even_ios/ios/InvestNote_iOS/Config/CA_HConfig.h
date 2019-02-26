//
//  CA_HConfig.h
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#ifndef CA_HConfig_h
#define CA_HConfig_h

//是否第一次
#define IsFirst @"CA_IsFirst"
//存储token的名字
#define Token   @"Token"
#define GetToken [[CA_HAppManager sharedManager] getToken]

//图片
#define kImage(imageName) [UIImage imageNamed:imageName]
//字体
#define kFont(size) [UIFont systemFontOfSize:kDevice_Is_iPhone5s?size-1:size]
//颜色
#define kColor(color) [UIColor colorWithHexString:color]
//
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
//导航栏高度
#define Navigation_Height kDevice_Is_iPhoneX ? 88 : 64
//手机型号
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 多语言
#define CA_H_LAN(str) [CA_HSetLanguage languageString:str]

// 字体
#define CA_H_FONT_PFSC_Regular(x) [UIFont fontWithName:@"PingFangSC-Regular" size:(x)*CA_H_RATIO_WIDTH]
#define CA_H_FONT_PFSC_Medium(x) [UIFont fontWithName:@"PingFangSC-Medium" size:(x)*CA_H_RATIO_WIDTH]
#define CA_H_FONT_PFSC_Light(x) [UIFont fontWithName:@"PingFangSC-Light" size:(x)*CA_H_RATIO_WIDTH]
#define CA_H_FONT_PFSC_Semibold(x) [UIFont fontWithName:@"PingFangSC-Semibold" size:(x)*CA_H_RATIO_WIDTH]

// 颜色
#define CA_H_TINTCOLOR UIColorHex(0x5E69C7)
#define CA_H_BACKCOLOR UIColorHex(0xEEEEEE)
#define CA_H_SHADOWCOLOR UIColorHex(0xCCCCCC)
#define CA_H_DCOLOR UIColorHex(0xDDDDDD)
#define CA_H_0BLACKCOLOR UIColorHex(0x000000)
#define CA_H_4BLACKCOLOR UIColorHex(0x444444)
#define CA_H_5BLACKCOLOR UIColorHex(0x555555)
#define CA_H_4DISABLEDCOLOR UIColorHex(0x4444447f)
#define CA_H_6GRAYCOLOR UIColorHex(0x666666)
#define CA_H_9GRAYCOLOR UIColorHex(0x999999)
#define CA_H_F8COLOR UIColorHex(0xF8F8F8)
#define CA_H_F4COLOR UIColorHex(0xF4F4F4)
#define CA_H_FCCOLOR UIColorHex(0xFCFCFC)
#define CA_H_BCOLOR UIColorHex(0xBBBBBB)

#define CA_H_FBCOLOR UIColorHex(0xFBFBFB)
#define CA_H_D8COLOR UIColorHex(0xD8D8D8)
// 红色
#define CA_H_REDCOLOR UIColorHex(0xFA8C8C)
#define CA_H_69REDCOLOR UIColorHex(0xFF6969)
#define CA_H_5AREDCOLOR UIColorHex(0xE95A5A)

// 屏幕宽高
#define CA_H_SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define CA_H_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

//屏幕尺寸适配
#define CA_H_RATIO_WIDTH  (CA_H_SCREEN_WIDTH / 375.0)
#define CA_H_RATIO_HEIGHT (CA_H_SCREEN_HEIGHT / 667.0) //不建议以高度做适配 影响控件宽高比例

//线粗
#define CA_H_LINE_Thickness  (CA_H_MANAGER.lineThickness)

// 效率的 NSLog

#if CA_H_Online == 4

#define NSLog(...) {\
NSString *calogstring = [NSString stringWithFormat:@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]];\
printf("%s", [calogstring UTF8String]);\
[[CADebugging sharedManager] debuggingLog:calogstring];\
}

#else

#ifdef DEBUG
#define NSLog(...) printf("%s", [[NSString stringWithFormat:@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]] UTF8String])

//NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else
#define NSLog(...)
#endif

#endif



// 弱引用宏
#define CA_H_WeakSelf(type)  __weak typeof(type) weak##type = type;
#define CA_H_StrongSelf(type)  __strong typeof(type) type = weak##type;

// view圆角边框
#define CA_H_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// 弧度/角度 转换
#define CA_H_DegreesToRadian(x) (M_PI * (x) / 180.0)
#define CA_H_RadianToDegrees(radian) (radian*180.0)/(M_PI)

// 获取UserDefaults
#define CA_H_UserDefaults [NSUserDefaults standardUserDefaults]

// 获取App版本号
#define CA_H_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 获取手机系统版本号
#define CA_H_SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 获取当前语言
#define CA_H_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// 获取通知中心
#define CA_H_NotificationCenter [NSNotificationCenter defaultCenter]

// 沙盒目录文件
//获取temp
#define CA_H_PathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define CA_H_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define CA_H_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// GCD
//GCD - 一次性执行
#define CA_H_DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define CA_H_DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define CA_H_DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);


#endif /* CA_HConfig_h */
