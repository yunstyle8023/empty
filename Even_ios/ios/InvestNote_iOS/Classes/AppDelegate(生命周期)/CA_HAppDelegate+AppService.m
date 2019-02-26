//
//  CA_HAppDelegate+AppService.m
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppDelegate+AppService.h"
#import <UMSocialCore/UMSocialCore.h>

#import "BPush.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <Bugly/Bugly.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "CA_MMessageDetailModel.h"
#import "CA_MNavigationController.h"
#import "CA_MTabBarController.h"
#import "CA_MApproveDetailVC.h"
#import "CA_HNoteDetailController.h"
#import "CA_HTodoDetailViewController.h"
#import "CA_HBorwseFileManager.h"
#import "CA_MNewProjectContentVC.h"
#import "CA_MMyApproveVC.h"

#import "CA_HRNScheduleDetailVC.h"//日程详情


#import <WXApi.h>


@implementation CA_HAppDelegate (AppService)



- (void)setApiKey {
    [AMapServices sharedServices].apiKey = CA_H_AMapServices_APIkey;
}


/**
 设置bugly
 */
- (void)bugs{
    [Bugly startWithAppId:CA_MBuglyID];
    NSString *userName = [CA_H_MANAGER userName];
    if (userName.length) {
        [Bugly setUserIdentifier:userName];
    }
}

/**
 设置自动管理键盘
 */
- (void)setKeyBoard{
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

/**
 设置友盟
 */
- (void)setUmSocial{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:CA_MUMAppkey];
    BOOL result = [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:CA_MWXAppKey appSecret:CA_MWXAppSecret redirectURL:nil];
    NSLog(@"result === %d",result);
}

- (void)setBPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{

    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
#if CA_H_Online == 0
    [BPush registerChannel:launchOptions apiKey:CA_M_BaiDuPush_AppKey pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:YES isDebug:NO];
#else
    [BPush registerChannel:launchOptions apiKey:CA_M_BaiDuPush_AppKey pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:YES isDebug:YES];
#endif
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    [BPush disableLbs];
    
    //百度推送
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userinfo = %@", userInfo);
    if (userInfo) {
        NSLog(@"从消息启动:%@", userInfo);
        //开始处理推送消息
        [BPush handleNotification:userInfo];
    }
    
}


#pragma mark-------------百度云推送方法开始------------
//在ios8系统中，还需要添加这个方法，通过新的API注册推送服务
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSLog(@"test成功==%@", deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError* error) {
        NSLog(@"resultresult == %@", result);
        /*第一次进入app时
         resultresult == {
         "app_id" = 2123023;   ****************
         "channel_id" = 4757037177054515240;
         "error_code" = 0;
         "request_id" = 2271523313;
         "response_params" =     {
         appid = 2123023;
         "channel_id" = 4757037177054515240;
         "user_id" = 641593467401680874;
         };
         "user_id" = 641593467401680874;
         }
         */
        /* 不是第一次进入app启动的时候
         resultresult == {
         appid = 2123023;   *******************
         "channel_id" = 4757037177054515240;
         "request_id" = 88888888;
         "user_id" = 641593467401680874;
         }
         */
        NSDictionary* dic = result;
        NSString* baid = ([dic objectForKey:@"appid"] ? [dic objectForKey:@"appid"] : [dic objectForKey:@"app_id"]) ? ([dic objectForKey:@"appid"] ? [dic objectForKey:@"appid"] : [dic objectForKey:@"app_id"]) : @"";
        NSString* buid = [dic objectForKey:@"user_id"] ? [dic objectForKey:@"user_id"] : @"";
        NSString* bcid = [dic objectForKey:@"channel_id"] ? [dic objectForKey:@"channel_id"] : @"";
        NSLog(@"channel_id = %@", bcid);
        [CA_H_UserDefaults setValue:bcid forKey:Channel_Id];
    }];
}

//当DeviceToken获取失败时，系统会调用此方法
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"DeviceToken获取失败，原因 = %@", error);
}

//收到推送通知,点击了通知栏的消息
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
    //App收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    NSLog(@"收到推送userinfo = %@", userInfo);
    
    //从通知栏点击打开应用的 角标就消失
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    CA_H_MANAGER.tabbarPoint.hidden = NO;
    
    CA_MMessageDetailModel* model = [CA_MMessageDetailModel modelWithDictionary:userInfo];
    
    if ([model.category isEqualToString:@"account"]) {//登录页
        [self cleanUserData];
    }
    
    if (application.applicationState == UIApplicationStateActive) {// 应用在前台运行的状态下 就不做处理了
    }else {//后台或杀死状态下 进行页面跳转处理
        
        if ([model.category isEqualToString:@"system"]) {//系统通知 权限变更
            
//            if([model.body.object_type isEqualToString:@"schedule"]){ //日程详情
//                CA_HRNScheduleDetailVC *vc = [CA_HRNScheduleDetailVC new];
//                vc.scheduleId = model.body.object_id;
//
//                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
//                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
//                return;
//            }
            
            CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
            [tabbar setSelectedIndex:0];
        }
        
        if ([model.category isEqualToString:@"task_expire"]) {//待办提醒 待办详情页
            CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
            NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                  @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
            vc.dic = dic;
            vc.viewModel.commentId = model.body.related_id;
            CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
            [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
        }
        
        if ([model.category isEqualToString:@"approval"]) {//审批通知
            if([model.body.notify_type isEqualToString:@"approval"]){
                CA_MApproveDetailVC *approvelDetailVC = [CA_MApproveDetailVC new];
                approvelDetailVC.approveID = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:approvelDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"approval_list"]){
                CA_MMyApproveVC *approvelVC = [CA_MMyApproveVC new];
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:approvelVC animated:NO];
            }
        }
        
        if ([model.category isEqualToString:@"comment"]) {//评论通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                vc.modelManager.commentId = model.body.related_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                      @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                vc.viewModel.commentId = model.body.related_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }
        }
        if ([model.category isEqualToString:@"project"]) {//项目通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                      @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"file"]){//文件预览页
                [CA_HBorwseFileManager browseCachesFile:model.body.notify_id fileName:model.body.file_name fileUrl:model.body.file_path controller:self.window.rootViewController];
            }else if([model.body.notify_type isEqualToString:@"dir"]){//文件夹
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_File;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"project"]){//项目
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"procedure"]){//项目进展页
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_Progress;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }
        }
    }
}

//收到推送通知,点击了通知栏的消息
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"********** iOS7.0之后 background **********");
    //App收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"收到推送userinfo = %@", userInfo);

    //从通知栏点击打开应用的 角标就消失
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    CA_H_MANAGER.tabbarPoint.hidden = NO;
    
    CA_MMessageDetailModel* model = [CA_MMessageDetailModel modelWithDictionary:userInfo];
    
    if ([model.category isEqualToString:@"account"]) {//登录页
        [self cleanUserData];
    }
    
    if (application.applicationState == UIApplicationStateActive) {// 应用在前台运行的状态下 就不做处理了
        
    }else {//后台或杀死状态下 进行页面跳转处理
        
        if ([model.category isEqualToString:@"system"]) {//系统通知 权限变更
            
//            if([model.body.object_type isEqualToString:@"schedule"]){ //日程详情
//                CA_HRNScheduleDetailVC *vc = [CA_HRNScheduleDetailVC new];
//                vc.scheduleId = model.body.object_id;
//
//                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
//                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
//                return;
//            }
            
            CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
            [tabbar setSelectedIndex:0];
        }
        
        if ([model.category isEqualToString:@"task_expire"]) {//待办提醒 待办详情页
            CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
            NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                  @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
            vc.dic = dic;
            vc.viewModel.commentId = model.body.related_id;
            CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
            [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
        }
        
        if ([model.category isEqualToString:@"approval"]) {//审批通知
            if([model.body.notify_type isEqualToString:@"approval"]){
                CA_MApproveDetailVC *approvelDetailVC = [CA_MApproveDetailVC new];
                approvelDetailVC.approveID = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:approvelDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"approval_list"]){
                CA_MMyApproveVC *approvelVC = [CA_MMyApproveVC new];
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:approvelVC animated:NO];
            }
        }
        
        if ([model.category isEqualToString:@"comment"]) {//评论通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                vc.modelManager.commentId = model.body.related_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                      @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                vc.viewModel.commentId = model.body.related_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }
        }
        if ([model.category isEqualToString:@"project"]) {//项目通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                      @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
            }else if([model.body.notify_type isEqualToString:@"file"]){//文件预览页
                [CA_HBorwseFileManager browseCachesFile:model.body.notify_id fileName:model.body.file_name fileUrl:model.body.file_path controller:self.window.rootViewController];
            }else if([model.body.notify_type isEqualToString:@"dir"]){//文件夹
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_File;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"project"]){//项目
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }else if([model.body.notify_type isEqualToString:@"procedure"]){//项目进展页
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_Progress;
                CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
                [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:projectDetailVC animated:NO];
            }
        }
        
        if ([model.category isEqualToString:@"task_expire"]) {//待办提醒 待办详情页
            CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
            NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                  @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
            vc.dic = dic;
            vc.viewModel.commentId = model.body.related_id;
            CA_MTabBarController *tabbar = (CA_MTabBarController*)self.window.rootViewController;
            [((CA_MNavigationController *)tabbar.selectedViewController) pushViewController:vc animated:NO];
        }
    }
    
    
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification{
    NSLog(@"接收本地通知啦");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark-------------百度云推送方法结束------------


// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

-(void)cleanUserData{
    //清理用户信息
    [[CA_HAppManager sharedManager] saveToken:@""];
    NSDictionary* accountStr =  [CA_H_UserDefaults objectForKey:NSLoginAccount];
    if ([NSObject isValueableObject:accountStr]) {
        NSDictionary* parameters = @{@"username": accountStr[@"username"],
                                     @"password": @""};
        [CA_H_UserDefaults setObject:parameters forKey:NSLoginAccount];
    }
    
    //
//    [CA_H_MANAGER saveDefaultItemKey:@""];
//    [CA_H_MANAGER saveDefaultItem:@""];
//    CA_MTabBarController* tabBarController = (CA_MTabBarController*)CA_H_MANAGER.mainWindow.rootViewController;
//    CA_MNavigationController* navi = tabBarController.viewControllers[1];
//    if ([[navi topViewController] isKindOfClass:[CA_MProjectVC class]]) {
//        [((CA_MProjectVC*)[navi topViewController]) setCurretItemStr];
//    }
    //
    [CA_H_MANAGER setUserName:@""];
    [CA_H_MANAGER setUserId:nil];
    //保存是否绑定了手机号
    [CA_H_MANAGER saveBingdPhoneNumber:NO];
    //切换登录页面
    [CA_H_MANAGER showLoginWindow:NO];
}

@end
