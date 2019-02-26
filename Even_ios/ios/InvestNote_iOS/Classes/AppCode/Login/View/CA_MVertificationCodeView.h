//
//  CA_M_VertificationCodeView.h
//  ceshi
//
//  Created by yezhuge on 2017/11/19.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VertificationCodeViewDelegate <NSObject>

@optional

/**
 验证码输入完成
 */
- (void)didFinishVertificationCode:(NSString*)vertificationCode;

/**
 删除验证码
 */
- (void)deleteVertificationCode:(NSString*)vertificationCode;

@end

/**
 分割验证码的View
 */

@interface CA_MVertificationCodeView : UIView
/// 背景图片
@property(nonatomic,copy)NSString* backgroudImageName;
/// 验证码/密码的位数
@property(nonatomic,assign)NSInteger numberOfVertificationCode;
/// 控制验证码/密码是否密文显示
@property(nonatomic,assign)bool secureTextEntry;
/// 验证码/密码内容，可以通过该属性拿到验证码/密码输入框中验证码/密码的内容
@property(nonatomic,copy)NSString* vertificationCode;
/// 代理,回传
@property(nonatomic,weak)id<VertificationCodeViewDelegate> delegate;
/// 调用键盘,成为第一响应者
-(void)becomeFirstResponder;

-(void)cleanVertificationCode;

@end
