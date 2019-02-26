//
//  CA_HAppManager+Share.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

@interface CA_HAppManager (Share)

/**
 原生分享
 */
- (void)share:(UIActivityViewControllerCompletionWithItemsHandler)myBlock text:(NSString *)text image:(UIImage *)image urlStr:(NSString *)urlStr;

- (void)shareH5:(id)url controller:(UIViewController *)vc block:(UIActivityViewControllerCompletionWithItemsHandler)block;

- (void)shareDetail:(UIViewController *)vc data_type:(NSString *)data_type data_id:(NSString *)data_id block:(UIActivityViewControllerCompletionWithItemsHandler)block;

@end
