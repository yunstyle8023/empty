//
//  ToolsTests.m
//  InvestNote_iOSTests
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CA_HShareActivity.h"

#import "CA_HSetLanguage.h"

#import "CA_HNetManager.h"

#import "CA_HLocationManager.h"

#import "CA_HLoginManager.h"

#define WAIT do {\
[self expectationForNotification:@"CA_HTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"CA_HTest" object:nil];

@interface ToolsTests : XCTestCase

@end

@implementation ToolsTests

- (void)testShareActivity{
    CA_HShareActivity * activityLong = [CA_HShareActivity newWithType:UIActivityTypeCACustomLong];
    XCTAssertNotNil(activityLong, @"activityLong创建失败");
    
    
    CA_HShareActivity * activityCopy = [CA_HShareActivity newWithType:UIActivityTypeCACustomCopy];
    XCTAssertNotNil(activityCopy, @"activityCopy创建失败");
}

- (void)testLanguage{
    
    NSString * str = @"测试";
    
    NSString * text = [CA_HSetLanguage languageString:str];
    
    XCTAssertEqualObjects(str, text, @"CA_HSetLanguage错误");
}

- (void)testShadow{
    
    UIView * view = [UIView new];
    CGRect  bounds =  view.bounds;
    CGFloat cornerRadius = 3;
    CGSize offset = CGSizeMake(3, 3);
    CGFloat radius = 3;
    UIColor * color = [UIColor redColor];
    CGFloat opacity = 0.3;
    
    
    
    [CA_HShadow dropShadowWithView:view
                            offset:offset
                            radius:radius
                             color:color
                           opacity:opacity];
    
    [CA_HShadow dropShadowWithView:view
                            bounds:bounds
                            offset:offset
                            radius:radius
                             color:color
                           opacity:opacity];
    
    [CA_HShadow dropShadowWithView:view
                            bounds:bounds
                      cornerRadius:cornerRadius
                            offset:offset
                            radius:radius
                             color:color
                           opacity:opacity];
}

- (void)testNetManager{
    
    [CA_HNetManager AFNReachability];
    
    
}

- (void)testAlert{
    
    [CA_H_MANAGER.mainWindow.rootViewController presentAlertTitle:@"title" message:@"message" buttons:@[@"取消",@"确定"] clickBlock:^(UIAlertController *alert, NSInteger index) {
        XCTAssertNotNil(alert, @"alert创建失败");
//        NOTIFY
    }];
//    WAIT
}

- (void)testLocationManager {
    XCTestExpectation *exception = [self expectationWithDescription:@"location"];
    
    CA_HLocationManager *manager = [CA_HLocationManager singleLocation:^(NSString *location) {
        [exception fulfill];
        XCTAssertTrue(location.length>0, @"定位失败");
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testLoginManager {
    XCTestExpectation *exception = [self expectationWithDescription:@"login"];
    
    NSDictionary *dict = @{@"username":@"test",
                           @"password":@"123456"};
    
    [CA_HLoginManager loginOrganization:dict callBack:^(CA_HNetModel *netModel) {
        [exception fulfill];
        XCTAssertTrue(netModel.type == CA_H_NetTypeSuccess, @"登录接口访问失败");
        XCTAssertTrue(netModel.errcode.integerValue == 0, @"登录失败");
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}



@end
