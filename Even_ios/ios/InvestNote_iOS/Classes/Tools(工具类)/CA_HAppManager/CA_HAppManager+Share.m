//
//  CA_HAppManager+Share.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager+Share.h"

#import "CA_HShareActivity.h"

@implementation CA_HAppManager (Share)


- (void)shareDetail:(UIViewController *)vc data_type:(NSString *)data_type data_id:(NSString *)data_id block:(UIActivityViewControllerCompletionWithItemsHandler)block {
    
    if (!(vc&&data_type&&data_id)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?data_type=%@&data_id=%@", CA_H_SERVER_API, CA_H_Api_ShareDetail, data_type, data_id];
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self shareH5:urlStr controller:vc block:block];
}


- (void)shareH5:(id)url controller:(UIViewController *)vc block:(UIActivityViewControllerCompletionWithItemsHandler)block {

    
    NSArray *activityItems = nil;
    
    if ([url isKindOfClass:[NSURL class]]) {
        activityItems = @[url];
    } else if ([url isKindOfClass:[NSString class]]) {
        activityItems = @[[NSURL URLWithString:url]];
    } else {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];

    activityVC.completionWithItemsHandler = block;
    
    [vc presentViewController:activityVC animated:TRUE completion:nil];
}

// 原生分享
- (void)share:(UIActivityViewControllerCompletionWithItemsHandler)myBlock text:(NSString *)text image:(UIImage *)image urlStr:(NSString *)urlStr {
    
    NSMutableArray *mut = [NSMutableArray new];
    
    if (text) [mut addObject:text];
    if (image) [mut addObject:image];
    if (urlStr) [mut addObject:[NSURL URLWithString:urlStr]];
    
    NSArray *activityItems = mut;
    
    CA_HShareActivity * longImage = [CA_HShareActivity newWithType:UIActivityTypeCACustomLong];
    CA_HShareActivity * copyLink = [CA_HShareActivity newWithType:UIActivityTypeCACustomCopy];
    
    NSArray * activities = @[longImage, copyLink];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:activities];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    
    //给activityVC的属性completionHandler写一个block。
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
//    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
//    {
//        NSLog(@"activityType :%@", activityType);
//        if (completed)
//        {
//            NSLog(@"completed");
//
//
//        }
//        else
//        {
//            NSLog(@"cancel");
//        }
//    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    
    UIViewController * rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:activityVC animated:TRUE completion:nil];
}

@end
