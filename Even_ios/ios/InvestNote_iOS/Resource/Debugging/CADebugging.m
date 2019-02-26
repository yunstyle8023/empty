//
//  CADebugging.m
//  InvestNote_iOSTests
//
//  Created by 韩云智 on 2018/4/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CADebugging.h"

@interface CADebugging ()

@end

@implementation CADebugging

+ (CADebugging *)sharedManager {
    
    if (CA_H_Online != 4) {
        return nil;
    }
    
    static CADebugging * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [self new];
        [share upConfig];
    });
    return share;
}

- (void)upConfig {
    self.api = [CA_H_UserDefaults objectForKey:@"CADebugging_api"]?:@"https://mobile.api.chengantech.com";
    NSDictionary *dic = [CA_H_UserDefaults dictionaryRepresentation];
    NSInteger index = [dic.allKeys indexOfObject:@"CADebugging_switch"];
    if (index == NSNotFound) {
        [CA_H_UserDefaults setBool:YES forKey:@"CADebugging_switch"];
    }
}

- (void)debuggingLog:(NSString *)log {
    [self.textView insertText:[[NSDate date] stringWithFormat:@"\n---HH:mm:ss---\n"]];
    [self.textView insertText:log];
}

#pragma mark --- Action

/**
 *  实现拖动手势方法
 *
 *  @param panGestureRecognizer 手势本身
 */
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [panGestureRecognizer translationInView:self.view.superview];
    //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
    panGestureRecognizer.view.center = CGPointMake(panGestureRecognizer.view.center.x + translation.x, panGestureRecognizer.view.center.y + translation.y);
    [CA_H_UserDefaults setObject:NSStringFromCGPoint(panGestureRecognizer.view.center) forKey:@"CADebugging_center"];
    //重置拖拽手势的姿态
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view.superview];
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.25 delay:0.75 options:0 animations:^{
                self.view.alpha = 0.4;
            } completion:nil];
        }
            break;
        case UIGestureRecognizerStateBegan:
        {
            self.view.alpha = 1;
        }
            break;
        default:
            
            break;
    }
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.25 delay:0.75 options:0 animations:^{
                self.view.alpha = 0.4;
            } completion:nil];
        }
            break;
        case UIGestureRecognizerStateBegan:
        {
            self.view.alpha = 1;
            
            if (self.controller.view.superview) {
                NSMutableArray *mut = [NSMutableArray arrayWithArray:@[@"新建域名",@"清空日志",@"https://mobile.api.chengantech.com",@"http://pre.chengantech.cn:8080",@"http://test.chengantech.cn:8899"]];
                NSArray *apis = [CA_H_UserDefaults objectForKey:@"CADebugging_apis"];
                [mut addObjectsFromArray:apis];
                
                NSString *massage = [NSString stringWithFormat:@"当前域名:%@", self.api];
                CA_H_WeakSelf(self);
                [self.controller presentActionSheetTitle:nil message:massage buttons:mut clickBlock:^(UIAlertController *alert, NSInteger index) {
                    CA_H_StrongSelf(self);
                    switch (index) {
                        case 0://新建
                            [self newApi];
                            break;
                        case 1://清空
                            self.textView.text = nil;
                            break;
                        default://选择
                        {
                            [self choose:index array:mut];
                        }
                            break;
                    }
                }];
            }
        }
            break;
        default:
            
            break;
    }
}

- (void)choose:(NSInteger)index array:(NSArray *)array {
    
    if (array.count > index) {
        NSString *text = array[index];
        NSArray *buttons = index>4?@[@"取消",@"删除",@"选择"]:@[@"取消",@"选择"];
        
        CA_H_WeakSelf(self);
        [self.controller presentAlertTitle:@"要对这个域名做什么" message:text buttons:buttons clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 0) {//取消
                
            } else if (index == buttons.count-1) {
                self.api = text;
                [self finish];
            }else if (index == 1) {
                NSArray *apis = [CA_H_UserDefaults objectForKey:@"CADebugging_apis"];
                NSInteger index = [apis indexOfObject:text];
                if (index != NSNotFound) {
                    NSMutableArray *mut = [NSMutableArray arrayWithArray:apis];
                    [mut removeObject:text];
                    [CA_H_UserDefaults setObject:mut forKey:@"CADebugging_apis"];
                }
            }
        }];
        
    }
}

- (void)newApi {
    CA_H_WeakSelf(self);
    [self.controller presentAlertTitle:@"新建域名" message:nil buttons:@[@"取消",@"确定"] clickBlock:^(UIAlertController *alert, NSInteger index) {
        CA_H_StrongSelf(self);
        if (index == 1) {
            NSString *text = [alert.textFields.firstObject text];
            [self newApiText:text];
        }
    } countOfTextField:1 textFieldBlock:^(UITextField *textField, NSInteger index) {
        textField.keyboardType = UIKeyboardTypeURL;
        textField.text = self.api;
    }];
}

- (void)newApiText:(NSString *)text {
    
    if (text.length) {
        self.api = text;
        NSArray *apis = [CA_H_UserDefaults objectForKey:@"CADebugging_apis"];
        
        NSInteger index = [apis indexOfObject:text];
        if (!apis || index == NSNotFound) {
            NSMutableArray *mut = [NSMutableArray arrayWithArray:apis];
            [mut addObject:text];
            [CA_H_UserDefaults setObject:mut forKey:@"CADebugging_apis"];
        }
        [self finish];
    }
    
}

- (void)finish {
    
    NSString *center = [CA_H_UserDefaults objectForKey:@"CADebugging_center"];
    NSArray *apis = [CA_H_UserDefaults objectForKey:@"CADebugging_apis"];
    
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [CA_H_UserDefaults removePersistentDomainForName:appDomain];
    
    NSArray *filePaths = @[CA_H_FileDocumentsDirectory, CA_H_ReportDocumentsDirectory, CA_H_EnterpriseReportDocumentsDirectory];
    for (NSString *filePath in filePaths) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    
    [CA_H_UserDefaults setBool:YES forKey:@"CADebugging_switch"];
    [CA_H_UserDefaults setObject:center forKey:@"CADebugging_center"];
    [CA_H_UserDefaults setObject:self.api forKey:@"CADebugging_api"];
    [CA_H_UserDefaults setObject:apis forKey:@"CADebugging_apis"];
    
    
    UIApplication *app = [UIApplication sharedApplication];
    [app.delegate application:app didFinishLaunchingWithOptions:nil];
    
    [self onButton:(id)self.view];
}

- (void)onButton:(UIButton *)sender {
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25 delay:0.75 options:0 animations:^{
        self.view.alpha = 0.4;
    } completion:nil];
    
    if (self.controller.view.superview) {
        [self.controller.view removeFromSuperview];
    } else {
        [self.view.superview addSubview:self.controller.view];
        [self.view.superview bringSubviewToFront:self.view];
    }
    [self.textView becomeFirstResponder];
    [self.textView resignFirstResponder];
}

#pragma mark --- Lazy

- (UIViewController *)controller {
    if (!_controller) {
        UIViewController *viewController = [UIViewController new];
        _controller = viewController;
        
        viewController.view.frame = [UIScreen mainScreen].bounds;
        [viewController.view addSubview:self.textView];
        self.textView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _controller;
}

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [UITextView new];
        _textView = textView;
        
        textView.editable = NO;
        textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _textView;
}

- (UIView *)view {
    if (!_view) {
        UIButton *view = [UIButton new];
        _view = view;
        
        view.size = CGSizeMake(50, 50);
        NSString *center = [CA_H_UserDefaults objectForKey:@"CADebugging_center"];
        view.center = center?CGPointFromString(center):CGPointMake(CA_H_SCREEN_WIDTH/2, CA_H_SCREEN_HEIGHT/2);
        
        [view addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self.view addGestureRecognizer:pan];
        
        UILongPressGestureRecognizer *lon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [self.view addGestureRecognizer:lon];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:@"Zapfino" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Debug";
        label.frame = CGRectMake(0, 0, 50, 50);
        label.textColor = [UIColor whiteColor];
        
        
        view.layer.cornerRadius = 25;
        view.layer.masksToBounds = YES;
        view.backgroundColor = CA_H_TINTCOLOR;
        
        [view addSubview:label];

    }
    return _view;
}

#pragma mark --- Custom

- (void)show:(UIView *)view {
    if (!self.view.superview) {
        self.view.alpha = 1;
        [UIView animateWithDuration:0.25 delay:0.75 options:0 animations:^{
            self.view.alpha = 0.4;
        } completion:nil];
    }
    [view addSubview:self.view];
}

- (void)hide {
    [self.view removeFromSuperview];
}

@end
