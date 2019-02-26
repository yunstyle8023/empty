
//
//  CA_MChangeWorkSpace.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MChangeWorkSpace.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"
#import "CA_HHomePageViewController.h"
#import "CA_HMineViewController.h"

#define CA_H_TABBAR_IMAGES @[   @"icon_home",\
                                @"icon_project",\
                                @"icon_me"]

#define CA_H_TABBAR_TITLES @[   @"首页",\
                                @"工作台",\
                                @"我的"]

@implementation CA_MChangeWorkSpace

+ (void)changeWorkSpace:(UIViewController*)controller{
    
    UIWindow* window = CA_H_MANAGER.mainWindow;
    CA_MTabBarController* tabBarController = (CA_MTabBarController*)window.rootViewController;
    if (tabBarController.selectedIndex == 1) {
        [[self alloc] replace:tabBarController controller:controller];
        [tabBarController setSelectedIndex:1];
        CA_H_MANAGER.mainWindow.rootViewController = tabBarController;
    }
    
}

+ (void)replaceWorkSpace:(UIViewController*)controller{
    UIWindow* window = CA_H_MANAGER.mainWindow;
    CA_MTabBarController* tabBarController = (CA_MTabBarController*)window.rootViewController;
    [[self alloc] replace:tabBarController controller:controller];
    CA_H_MANAGER.mainWindow.rootViewController = tabBarController;
}

-(void)replace:(CA_MTabBarController*)tabBarController controller:(UIViewController*)controller{
    NSMutableArray* resultViewControllers = [[NSMutableArray alloc] init];
    NSArray * viewControllers= tabBarController.viewControllers;
    for (int i=0; i<viewControllers.count; i++) {
        CA_MNavigationController* subViewController = viewControllers[i];
        if (i == 1) {
            CA_MNavigationController* navi = [[CA_MNavigationController alloc] initWithRootViewController:controller];
            navi.tabBarItem.title = @"工作台";
            navi.tabBarItem.image = [kImage(@"icon_project") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navi.tabBarItem.selectedImage = kImage(@"icon_project_hover");
            [navi.tabBarItem setImageInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
            [navi.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
            [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10], NSForegroundColorAttributeName:UIColorHex(0xB9BCCD)} forState:UIControlStateNormal];
            [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10], NSForegroundColorAttributeName:CA_H_TINTCOLOR} forState:UIControlStateSelected];
            
            [resultViewControllers addObject:navi];
        }else{
            [resultViewControllers addObject:subViewController];
        }
    }
    
    [tabBarController setViewControllers:resultViewControllers];
}

@end
