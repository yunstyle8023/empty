//
//  CA_HAppManager.m
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

#import "CA_MOrganizationLoginVC.h"

#import "CA_MNavigationController.h"


@interface CA_HAppManager ()

@end

@implementation CA_HAppManager

- (double)lineThickness {
    if (!_lineThickness) {
        double scale = [UIScreen mainScreen].scale;
        if (scale==3) {
            _lineThickness = 2.0/scale;
        } else if (scale == 2) {
            _lineThickness = 0.5;
        } else {
            _lineThickness = 1;
        }
    }
    return _lineThickness;
}

+ (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (@available(iOS 11.0, *)) {
        if ([text isEqualToString:@"-"]) {
            [textView insertText:@"–"];
//            [textView insertText:@" -"];
            return NO;
        }
    }
    
    return YES;
}


/**
    单例

 @return 单例对象
 */
+ (CA_HAppManager *)sharedManager
{
    static CA_HAppManager * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [self new];
        share.lanType = CA_H_Language_ChineseSimplified;
        [share upAppearanceConfig];
        // 监听网络状态
        share.status = AFNetworkReachabilityStatusUnknown;
        [CA_HNetManager AFNReachability];
    });
    return share;
}

- (void)setStatus:(AFNetworkReachabilityStatus)status{
    _status = status;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"未知");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"没有网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"3G");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WIFI");
            break;
            
        default:
            break;
    }
}

/**
    全局配置
 */
- (void)upAppearanceConfig{
    
    // tabBar
    UITabBar.appearance.translucent = NO;
    UITabBar.appearance.backgroundColor = [UIColor whiteColor];
    UITabBar.appearance.shadowImage = [UIImage new];
    UITabBar.appearance.backgroundImage = [UIImage new];
    UITabBar.appearance.tintColor = CA_H_TINTCOLOR;
    
    // navbar
    UINavigationBar.appearance.translucent = NO;
    UINavigationBar.appearance.backgroundColor = [UIColor whiteColor];
    UINavigationBar.appearance.barStyle = UIBarStyleDefault;
    UINavigationBar.appearance.shadowImage = [UIImage new];
    [UINavigationBar.appearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar.appearance.backItem setHidesBackButton:YES];
    UINavigationBar.appearance.tintColor = CA_H_TINTCOLOR;
    UINavigationBar.appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:17], NSForegroundColorAttributeName:CA_H_4BLACKCOLOR};
    
    // table
    UITableView.appearance.estimatedRowHeight = 0;
    UITableView.appearance.estimatedSectionFooterHeight = 0;
    UITableView.appearance.estimatedSectionHeaderHeight = 0;
    UITableView.appearance.separatorColor = CA_H_BACKCOLOR;

    
    // searchBar
    UISearchBar.appearance.backgroundImage = [UIImage new];
    UISearchBar.appearance.barTintColor = [UIColor whiteColor];
    
}

- (BOOL)shouldEventCalendar {
    return ![CA_H_UserDefaults boolForKey:@"shouldNotEventCalendar"];
}

- (void)setShouldEventCalendar:(BOOL)shouldEventCalendar {
    [CA_H_UserDefaults setBool:!shouldEventCalendar forKey:@"shouldNotEventCalendar"];
    [CA_H_UserDefaults synchronize];
}

// tabbar 我的点
- (UIView *)tabbarPoint {
    if (!_tabbarPoint) {
        UIView *point = [UIView new];
        _tabbarPoint = point;
        
        point.backgroundColor = CA_H_69REDCOLOR;
        point.hidden = YES;
    }
    return _tabbarPoint;
}

/**
    登录window层
 */
- (UIWindow *)loginWindow{
    if (!_loginWindow) {
        _loginWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _loginWindow.mj_y = _loginWindow.mj_h;
        _loginWindow.backgroundColor = [UIColor clearColor];
        _loginWindow.windowLevel = UIWindowLevelNormal + 2;
        
        CA_MNavigationController* nav = [[CA_MNavigationController alloc] initWithRootViewController:[CA_MOrganizationLoginVC new]];

        // 登录
        _loginWindow.rootViewController = nav;
        
        [_loginWindow makeKeyAndVisible];
    }
    return _loginWindow;
}


/**
    系统相册
 */
- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}


@end
