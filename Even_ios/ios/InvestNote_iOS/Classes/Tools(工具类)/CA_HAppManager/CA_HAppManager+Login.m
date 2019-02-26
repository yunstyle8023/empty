//
//  CA_HAppManager+Login.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager+Login.h"

@implementation CA_HAppManager (Login)

//

- (void)showLoginWindow:(BOOL)animated {
    [self showLoginWindow:animated completion:nil];
}

- (void)showLoginWindow:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
    [self.loginWindow becomeKeyWindow];
    self.loginWindow.hidden = NO;
    [UIView animateWithDuration:(animated?0.25:0) animations:^{
        self.loginWindow.mj_y = 0;
    } completion:completion];
    
#if CA_H_Online == 4
    if ([CA_H_UserDefaults boolForKey:@"CADebugging_switch"]) {
        [[CADebugging sharedManager] show:self.loginWindow];
    }
#endif
    
}

- (void)hideLoginWindow:(BOOL)animated{
    [UIView animateWithDuration:(animated?0.25:0) animations:^{
        self.loginWindow.mj_y = self.loginWindow.mj_h;
    } completion:^(BOOL finished) {
        [self.loginWindow resignKeyWindow];
        self.loginWindow.hidden = YES;
        self.loginWindow = nil;
    }];
    
#if CA_H_Online == 4
    if ([CA_H_UserDefaults boolForKey:@"CADebugging_switch"]) {
        [[CADebugging sharedManager] show:self.mainWindow];
    }
#endif
    
}


@end
