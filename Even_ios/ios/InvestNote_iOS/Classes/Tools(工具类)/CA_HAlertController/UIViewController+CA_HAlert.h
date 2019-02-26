//
//  UIViewController+CA_HAlert.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CA_HAlert)

- (UIAlertController *)presentAlertTitle:(NSString *)title
                  message:(NSString *)message
                  buttons:(NSArray *)buttons
               clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock;

- (UIAlertController *)presentAlertTitle:(NSString *)title
                  message:(NSString *)message
                  buttons:(NSArray *)buttons
               clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock
         countOfTextField:(NSInteger)count
           textFieldBlock:(void (^)(UITextField *textField, NSInteger index))textFieldBlock;

- (UIAlertController *)presentActionSheetTitle:(NSString *)title
                        message:(NSString *)message
                        buttons:(NSArray *)buttons
                     clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock;

@end
