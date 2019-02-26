//
//  HomePageTests.m
//  InvestNote_iOSTests
//
//  Created by 韩云智 on 2018/1/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "CA_HHomePageViewController.h"

#import "CA_HMoveListViewController.h"

#import "CA_HHomeSearchViewController.h"

#import "CA_HEditNoteViewController.h"

#import "CA_HAddTodoViewController.h"

#import "CA_HRemarkViewController.h"

#import "CA_HLongViewController.h"

#import "CA_HAddFileViewController.h"
#import "CA_HChooseFolderViewController.h"
#import "CA_HChooseFolderListViewController.h"

#import "CA_HBrowseFoldersViewController.h"

@interface HomePageTests : XCTestCase

@end

@implementation HomePageTests

- (void)testHomePage{
    
    CA_HHomePageViewController * homePageVC = [CA_HHomePageViewController new];
    [homePageVC view];
    
    XCTAssertNotNil(homePageVC, @"homePageVC创建失败");
    
}

- (void)testMoveList{
    
    CA_HMoveListViewController * moveListVC = [CA_HMoveListViewController new];
    [moveListVC view];
    
    XCTAssertNotNil(moveListVC, @"moveListVC创建失败");
}

- (void)testSearch{
    
    CA_HHomeSearchViewController * searchVC = [CA_HHomeSearchViewController new];
    [searchVC view];
    
    XCTAssertNotNil(searchVC, @"searchVC创建失败");
}

- (void)testEditNote{

    CA_HEditNoteViewController * editNoteVC = [CA_HEditNoteViewController new];
    [editNoteVC view];

    XCTAssertNotNil(editNoteVC, @"editNoteVC创建失败");
}

- (void)testAddTodo{
    
    CA_HAddTodoViewController * addTodoVC = [CA_HAddTodoViewController new];
    [addTodoVC view];
    
    XCTAssertNotNil(addTodoVC, @"addTodoVC创建失败");
}

- (void)testRemark{
    
    CA_HRemarkViewController * remarkVC = [CA_HRemarkViewController new];
    [remarkVC view];
    
    XCTAssertNotNil(remarkVC, @"remarkVC创建失败");
}

- (void)testLong{
    
    CA_HLongViewController * longVC = [CA_HLongViewController new];
    [longVC view];
    
    XCTAssertNotNil(longVC, @"longVC创建失败");
}

- (void)testAddFile{
    
    CA_HAddFileViewController * addFileVC = [CA_HAddFileViewController new];
    [addFileVC view];
    
    CA_HChooseFolderViewController * chooseFolderVC = [CA_HChooseFolderViewController new];
    [chooseFolderVC view];
    
    CA_HChooseFolderListViewController * chooseFolderListVC = [CA_HChooseFolderListViewController new];
    [chooseFolderListVC view];
    
    XCTAssertNotNil(addFileVC, @"addFileVC创建失败");
    XCTAssertNotNil(chooseFolderVC, @"chooseFolderVC创建失败");
    XCTAssertNotNil(chooseFolderListVC, @"chooseFolderListVC创建失败");
}

- (void)testBrowseFolders{
    
    CA_HBrowseFoldersViewController * browseFoldersVC = [CA_HBrowseFoldersViewController new];
    
    
    [browseFoldersVC view];
    
    XCTAssertNotNil(browseFoldersVC, @"browseFoldersVC创建失败");
}

@end
