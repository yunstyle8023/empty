//
//  CA_HRNAddScheduleVC.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRNAddScheduleVC.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface CA_HRNAddScheduleVC ()

@end

@implementation CA_HRNAddScheduleVC
    
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSURL *jsCodeLocation;
//
//        jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
        NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
        RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                            moduleName:@"zhongguancun"
                                                     initialProperties:nil
                                                         launchOptions:nil];
        rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        self.view = rootView;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
