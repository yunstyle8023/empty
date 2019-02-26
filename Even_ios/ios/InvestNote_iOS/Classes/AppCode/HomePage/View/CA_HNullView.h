//
//  CA_HNullView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HNullView : UIView


/**
 空页面

 @param title 展示文字
 @param buttonTitle 按钮展示文字
 @param top 上边距
 @param block 按钮事件回调
 @param imageName 展示图片名
 @return 空页面view
 */
+ (instancetype)newTitle:(NSString *)title
             buttonTitle:(NSString *)buttonTitle
                  top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName;

@end
