//
//  CA_HAppManager+Sound.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/5.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

@interface CA_HAppManager (Sound)

- (void)startRecord;
- (void)stopRecord;
- (void)playRecord:(NSURL *)recordUrl viewController:(UIViewController *)viewController;

@end
