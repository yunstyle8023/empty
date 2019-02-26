//
//  CA_HAppManager+Login.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

@interface CA_HAppManager (Login)


/**
 登录window层
 */
- (void)showLoginWindow:(BOOL)animated;
- (void)showLoginWindow:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;
- (void)hideLoginWindow:(BOOL)animated;

@end
