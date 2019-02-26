//
//  CA_MNavigationController.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/20.
//  God bless me without no bugs.
//

#import "CA_MNavigationController.h"

@interface CA_MNavigationController ()

@end

@implementation CA_MNavigationController

#pragma mark - LifeCycle

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Public

#pragma mark - Private

#pragma mark - Getter and Setter

@end
