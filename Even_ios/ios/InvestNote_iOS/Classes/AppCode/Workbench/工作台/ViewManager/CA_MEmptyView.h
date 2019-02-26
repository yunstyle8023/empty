//
//  CA_MEmptyView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MEmptyView : UIView

+ (instancetype)newTitle:(NSString *)title
             buttonTitle:(NSString *)buttonTitle
                     top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName;

+ (instancetype)newTitle:(NSString *)title
              messageStr:(NSString *)messageStr
             buttonTitle:(NSString *)buttonTitle
                     top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName;

- (void)updateTitle:(NSString*)title
        buttonTitle:(NSString *)buttonTitle
          imageName:(NSString*)imageName;
@end
