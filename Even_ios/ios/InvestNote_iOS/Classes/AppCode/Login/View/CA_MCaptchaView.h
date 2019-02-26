//
//  CA_MCaptchaView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MCaptchaView : UIView
@property(nonatomic,strong)NSMutableString* changeString;  //验证码的字符串
-(void)changeCaptcha;
@end
