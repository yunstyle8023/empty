//
//  UIViewController+CA_HAlert.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "UIViewController+CA_HAlert.h"

@implementation UIViewController (CA_HAlert)

- (UIAlertController *)presentAlertTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock{
    return [self presentAlertTitle:title message:message buttons:buttons clickBlock:clickBlock countOfTextField:0 textFieldBlock:nil];
}

- (UIAlertController *)presentAlertTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock countOfTextField:(NSInteger)count textFieldBlock:(void (^)(UITextField *textField, NSInteger index))textFieldBlock{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    CA_H_WeakSelf(alert);
    for (NSInteger i = 0; i < buttons.count; i++) {
        NSString *title = buttons[i];
        if ([title isKindOfClass:[NSString class]]) {
            [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                CA_H_StrongSelf(alert);
                if (clickBlock) {
                    clickBlock(alert, i);
                }
            }]];
        } else {
            [alert addAction:[UIAlertAction actionWithTitle:buttons[i][0] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                CA_H_StrongSelf(alert);
                if (clickBlock) {
                    clickBlock(alert, i);
                }
            }]];
        }
        
    }
    
    // 添加输入框
    for (NSInteger i = 0; i < count; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if (textFieldBlock) {
                textFieldBlock(textField, i);
            }
        }];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    return alert;
}

- (UIAlertController *)presentActionSheetTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons clickBlock:(void(^)(UIAlertController * alert, NSInteger index))clickBlock{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加按钮
    CA_H_WeakSelf(alert);
    for (NSInteger i = 0; i < buttons.count; i++) {
        NSString *title = buttons[i];
        if ([title isKindOfClass:[NSString class]]) {
            [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                CA_H_StrongSelf(alert);
                if (clickBlock) {
                    clickBlock(alert, i);
                }
            }]];
        } else {
            [alert addAction:[UIAlertAction actionWithTitle:buttons[i][0] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                CA_H_StrongSelf(alert);
                if (clickBlock) {
                    clickBlock(alert, i);
                }
            }]];
        }
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:CA_H_LAN(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        NSLog(@"点击了取消按钮");
    }]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    return alert;
}

@end
