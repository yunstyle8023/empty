//
//  RootControllerTests.m
//  InvestNote_iOSTests
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CA_MTabBarController.h"

#import "CA_HAppManager.h" // 单例
#import "CA_HAppManager+Login.h"
#import "CA_HAppManager+Share.h"
#import "CA_HAppManager+ImagePicker.h"
#import "CA_HAppManager+Sound.h"
#import "CA_HAppManager+File.h"

@interface RootControllerTests : XCTestCase

@end

@implementation RootControllerTests

- (void)testTabBar{
    
    CA_MTabBarController * tbc = [CA_MTabBarController new];
    
    XCTAssertNotNil(tbc, @"CA_MTabBarController创建失败");
    
    NSArray * titles = @[@"首页", @"工作台", @"我的"];
    for (int i = 0; i < 3; i++) {
        XCTAssertEqualObjects([tbc.childViewControllers[i] tabBarItem].title, titles[i], @"CA_MTabBarController标签标题错误");
    }
    
}

- (void)testAppManager{ 
    
    CA_HAppManager * manager = CA_H_MANAGER;
    XCTAssertNotNil(manager, @"CA_HAppManager创建失败");
    
    CA_HAppManager * manager2 = [CA_HAppManager sharedManager];
    XCTAssertEqualObjects(manager, manager2, @"单例创建失败");
    
    [manager showLoginWindow:YES];
    [manager hideLoginWindow:YES];
    
//    [manager share:nil];
    
    [manager selectImageFromAlbum:[UIViewController new]];
    [manager selectImageFromCamera:[UIViewController new]];
    
//    [manager startRecord];
//    [manager stopRecord];
    
    [manager presentDocumentPicker:[UIViewController new]];
    
}

@end
