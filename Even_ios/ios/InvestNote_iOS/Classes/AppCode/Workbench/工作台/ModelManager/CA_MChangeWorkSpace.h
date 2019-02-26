//
//  CA_MChangeWorkSpace.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MChangeWorkSpace : NSObject
/**
 切换控制台
 
 @param controller 需要显示的控制器
 */
+ (void)changeWorkSpace:(UIViewController*)controller;

+ (void)replaceWorkSpace:(UIViewController*)controller;
@end
