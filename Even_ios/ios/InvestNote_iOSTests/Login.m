//
//  Login.m
//  InvestNote_iOS
//  Created by maran on 2017/12/12.
//  God bless me without no bugs.
//

#import <XCTest/XCTest.h>
#import "CA_HAppDelegate.h"
#import "CA_HAppManager.h"
#import "CA_MTabBarController.h"

@interface Login : XCTestCase

@end

@implementation Login

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testLogin{
    
    [[CA_HAppManager sharedManager] saveToken:Token];
    
    NSString* token =  [[CA_HAppManager sharedManager] getToken];
    
    XCTAssertEqualObjects(Token, token, @"已经登录");
    
}

@end
