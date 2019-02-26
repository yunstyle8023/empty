//
//  CA_HAppManager.h
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    CA_H_Language_ChineseSimplified = 0,
    CA_H_Language_English,
} CA_H_LanguageType;

#define CA_H_MANAGER [CA_HAppManager sharedManager]

@interface CA_HAppManager : NSObject

@property (nonatomic, assign) BOOL shouldEventCalendar;

@property (nonatomic, assign) double lineThickness;//线宽
@property (nonatomic, assign) double xheight;
//@property (nonatomic, strong) NSNumber *user_id;

// 语言类型 默认0 简体中文
@property (nonatomic, assign) CA_H_LanguageType lanType;

// AFN 监听网络状态
@property (nonatomic, assign) AFNetworkReachabilityStatus status;

// 全局控件
@property (nonatomic, strong) UIWindow * mainWindow; 
@property (nonatomic, strong) UIWindow * loginWindow;

// 图片选择器
@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@property (nonatomic, copy) void (^imageBlock)(BOOL success, UIImage * image, NSDictionary * info);

@property (nonatomic, strong) AVAudioRecorder * recorder;//录音器
@property (nonatomic, copy) NSString * recordFileName; //文件地址
@property (nonatomic, copy) void (^recorderStopBlock)(void);

// 文件浏览器
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, copy) void (^fileBlock)(NSString *filePath, NSData *data);


// tabbar 我的点
@property (nonatomic, strong) UIView *tabbarPoint;

/**
    单例
 
 @return 单例对象
 */
+ (CA_HAppManager *)sharedManager;




+ (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;


@end
