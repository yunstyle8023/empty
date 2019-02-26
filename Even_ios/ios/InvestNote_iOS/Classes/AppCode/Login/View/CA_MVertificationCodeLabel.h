//
//  CA_M_VertificationCodeLabel.h
//  ceshi
//
//  Created by yezhuge on 2017/11/19.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 分割验证码的Label
 */
@interface CA_MVertificationCodeLabel : UILabel
/// 验证码/密码的位数
@property(nonatomic,assign)NSInteger numberOfVertificationCode;
/// 控制验证码/密码是否密文显示
@property(nonatomic,assign)bool secureTextEntry;
/// 标识是输入还是删除
@property(nonatomic,assign)bool isDelete;

@property (nonatomic,assign,getter=isFirstResponder) BOOL firstResponder;

@end
