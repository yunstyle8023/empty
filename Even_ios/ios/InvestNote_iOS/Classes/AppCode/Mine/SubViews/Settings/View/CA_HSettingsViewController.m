//
//  CA_HSettingsViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSettingsViewController.h"

#import "CA_HSettingsViewModel.h"
#import "CA_HSettingsViewManager.h"

#import "CA_HBaseTableCell.h"
#import "CA_MFeedbackVC.h"
#import "CA_MBandingNumberVC.h"
#import "CA_MUpdatePwdVC.h"
#import "CA_MAboutVC.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"
#import "CA_MChangeNumberVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>

#import <UMSocialCore/UMSocialCore.h>

#import "CA_HSettingsCell.h"

@interface CA_HSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HSettingsViewModel *viewModel;
@property (nonatomic, strong) CA_HSettingsViewManager *viewManager;

@end

@implementation CA_HSettingsViewController

#pragma mark --- Action

- (void)onLogout:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    CA_H_WeakSelf(self);
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        CA_H_StrongSelf(self);
        [CA_HNetManager postUrlStr:CA_H_Api_Logout parameters:nil callBack:nil progress:nil];
        //清理用户信息
        [[CA_HAppManager sharedManager] saveToken:@""];
        NSDictionary* accountStr =  [CA_H_UserDefaults objectForKey:NSLoginAccount];
        if ([NSObject isValueableObject:accountStr]) {
            NSDictionary* parameters = @{@"username": accountStr[@"username"],
                                         @"password": @""};
            [CA_H_UserDefaults setObject:parameters forKey:NSLoginAccount];
        }
        
        //
//        [CA_H_MANAGER saveDefaultItemKey:@""];
//        [CA_H_MANAGER saveDefaultItem:@""];
//        CA_MTabBarController* tabBarController = (CA_MTabBarController*)CA_H_MANAGER.mainWindow.rootViewController;
//        CA_MNavigationController* navi = tabBarController.viewControllers[1];
//        if ([[navi topViewController] isKindOfClass:[CA_MProjectVC class]]) {
//            [((CA_MProjectVC*)[navi topViewController]) setCurretItemStr];
//        }
        //
        [CA_H_MANAGER setUserName:@""];
        [CA_H_MANAGER setUserId:nil];
        //保存是否绑定了手机号
        [CA_H_MANAGER saveBingdPhoneNumber:NO];
        [CA_H_MANAGER saveUserWeChat:NO];
        //切换登录页面
        CA_H_WeakSelf(self);
        [CA_H_MANAGER showLoginWindow:YES completion:^(BOOL finished) {
            CA_H_StrongSelf(self);
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }];
        
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

- (void)onSwitch:(UISwitch *)sender {
    [CA_H_UserDefaults setBool:sender.on forKey:@"CADebugging_switch"];
    CADebugging *debug = [CADebugging sharedManager];
    if (sender.on) {
        [debug show:CA_H_MANAGER.mainWindow];
    } else {
        [debug hide];
    }
}

- (void)onCalendarSwitch:(UISwitch *)sender {
    CA_H_MANAGER.shouldEventCalendar = sender.on;
}

#pragma mark --- Lazy

- (CA_HSettingsViewModel *)viewModel {
    if (!_viewModel) {
        CA_HSettingsViewModel *viewModel = [CA_HSettingsViewModel new];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (CA_HSettingsViewManager *)viewManager {
    if (!_viewManager) {
        CA_HSettingsViewManager *viewManager = [CA_HSettingsViewManager new];
        _viewManager = viewManager;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    [super viewWillAppear:animated];
    
    if ([NSString isValueableString:[CA_H_MANAGER userPhone]]) {
        [_viewManager.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    
#if CA_H_Online == 4
    UISwitch *slider = [UISwitch new];
    slider.frame = CGRectMake(0, 0, 88, 44);
    [slider addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:slider];
    
    slider.on = [CA_H_UserDefaults boolForKey:@"CADebugging_switch"];
#endif
    
    self.title = self.viewModel.title;
    
    self.viewManager.tableView.dataSource = self;
    self.viewManager.tableView.delegate = self;
    
    [self.viewManager.button addTarget:self action:@selector(onLogout:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {//日历同步
        CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"日历同步"];
        if (!cell) {
            cell = [[CA_HSettingsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"日历同步"];
            UISwitch *slider = [UISwitch new];
            slider.tag = 1004;
            slider.frame = CGRectMake(CA_H_SCREEN_WIDTH-71.0, (53*CA_H_RATIO_WIDTH-31.0)/2.0, 51.0, 31.0);
            [slider addTarget:self action:@selector(onCalendarSwitch:) forControlEvents:UIControlEventTouchUpInside];
            slider.on = CA_H_MANAGER.shouldEventCalendar;
            [cell.contentView addSubview:slider];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.viewModel.data[indexPath.row];
        return cell;
    }
    
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.viewModel.data[indexPath.row];
    
    switch (indexPath.row) {
//        case 1:
//            cell.detailTextLabel.text = [CA_H_MANAGER userWeChat]?@"已绑定":@"未绑定";
//            break;
        case 1://2:
            cell.detailTextLabel.text = [CA_H_MANAGER userPhone];
            break;
        case 4:{//5:{
            NSInteger cache = [YYImageCache sharedCache].diskCache.totalCost;
            
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:CA_H_FileCachesDirectory];
            NSString *cacheRecordPath = [NSHomeDirectory() stringByAppendingPathComponent:CA_H_RecordCachesDirectory];

            long long size = [CA_HSettingsViewModel folderSizeAtPath:cacheFilePath]+[CA_HSettingsViewModel folderSizeAtPath:cacheRecordPath]+cache;
            
            NSString *sizeStr = @"0K";
            if (size>=1024*1024) {
                sizeStr = [NSString stringWithFormat:@"%ldM",(long)(size/(1024.0*1024.0))];
            } else if (size>=1024) {
                sizeStr = [NSString stringWithFormat:@"%ldK",(long)(size/1024.0)];
            }
            cell.detailTextLabel.text = sizeStr;
        }break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HBaseTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0://修改密码
        {
            CA_MUpdatePwdVC* updatePwdVC = [CA_MUpdatePwdVC new];
            [self.navigationController pushViewController:updatePwdVC animated:YES];
        }
            break;
//        case 1://绑定微信
//        {
//            if (![CA_H_MANAGER userWeChat]) {
//                if ([WXApi isWXAppInstalled]) {
//                    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//
//                        if (!error) {
//                            UMSocialUserInfoResponse *resp = result;
//
//                            // 授权信息
//                            NSLog(@"Wechat uid: %@", resp.uid);
//                            NSLog(@"Wechat openid: %@", resp.openid);
//                            NSLog(@"Wechat unionid: %@", resp.unionId);
//                            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//                            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//                            NSLog(@"Wechat expiration: %@", resp.expiration);
//
//                            // 用户信息
//                            NSLog(@"Wechat name: %@", resp.name);
//                            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//                            NSLog(@"Wechat gender: %@", resp.unionGender);
//
//                            // 第三方平台SDK源数据
//                            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//
//                            NSDictionary *parameters = @{ @"open_id": resp.openid,         //# 必填
//                                                          @"union_id": resp.unionId         //# 必填
//                                                          };
//                            [CA_HProgressHUD showHudStr:@"微信绑定中"];
//                            [CA_HNetManager postUrlStr:CA_M_Api_GenweChatBind parameters:parameters callBack:^(CA_HNetModel *netModel) {
//                                [CA_HProgressHUD hideHud];
//                                if (netModel.type == CA_H_NetTypeSuccess) {
//                                    if (netModel.errcode.intValue == 0) {
//                                        [CA_H_MANAGER saveUserWeChat:YES];
//                                        [self.viewManager.tableView reloadData];
////                                        [self.navigationController popViewControllerAnimated:YES];
//                                    }else{
//                                        [CA_HProgressHUD showHudStr:netModel.errmsg];
//                                    }
//                                }
////                                else{
////                                    [CA_HProgressHUD showHudStr:netModel.errmsg];
////                                }
//                            } progress:nil];
//                        }
//
//                    }];
//                }else{
//                    [CA_HProgressHUD showHudStr:@"暂未安装微信"];
//                }
//            }else{
//                [self presentActionSheetTitle:nil message:nil buttons:@[@[CA_H_LAN(@"解除绑定")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
//                    [CA_HProgressHUD showHudStr:@"解除绑定中"];
//                    [CA_HNetManager postUrlStr:CA_M_Api_GenweChatUnBind parameters:@{} callBack:^(CA_HNetModel *netModel) {
//                        [CA_HProgressHUD hideHud];
//                        if (netModel.type == CA_H_NetTypeSuccess) {
//                            if (netModel.errcode.intValue == 0) {
//                                [CA_H_MANAGER saveUserWeChat:NO];
//                                [self.viewManager.tableView reloadData];
////                                [self.navigationController popViewControllerAnimated:YES];
//                            }else{
//                                [CA_HProgressHUD showHudStr:netModel.errmsg];
//                            }
//                        }
//                        //                                else{
//                        //                                    [CA_HProgressHUD showHudStr:netModel.errmsg];
//                        //                                }
//                    } progress:nil];
//                }];
//            }
//        }
//            break;
        case 1://2://绑定手机
        {
            if ([NSString isValueableString:[CA_H_MANAGER userPhone]]) {
                CA_MChangeNumberVC* changeVC = [CA_MChangeNumberVC new];
                changeVC.numberStr = [CA_H_MANAGER userPhone];
                [self.navigationController pushViewController:changeVC animated:YES];
            }else{
                CA_MBandingNumberVC* bandingVC = [CA_MBandingNumberVC new];
                bandingVC.navigationTitle = @"绑定手机";
                bandingVC.buttonTitle = @"绑定新号码";
                bandingVC.changeNumber = NO;
                [self.navigationController pushViewController:bandingVC animated:YES];
            }
        }
            break;
        case 2://3://关于我们
        {
            CA_MAboutVC* aboutVC = [CA_MAboutVC new];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 3://4://帮助与反馈
        {
            CA_MFeedbackVC* feedBackVC = [CA_MFeedbackVC new];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
        case 4://5://清除缓存
        {
            [self presentActionSheetTitle:nil message:@"缓存数据包括笔记、任务、附件、图片等，清理后，再次查看需要重新下载" buttons:@[@[CA_H_LAN(@"清除缓存")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
                
                [CA_HSettingsViewModel clearCache];
                cell.detailTextLabel.text = @"0K";
//                [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
            break;
        default:
//            [CA_HProgressHUD showHudStr:@"暂未开通 敬请期待"];
            break;
    }
}


@end
