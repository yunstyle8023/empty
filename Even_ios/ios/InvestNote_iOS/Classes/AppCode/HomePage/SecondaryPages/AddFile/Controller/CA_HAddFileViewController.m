//
//  CA_HAddFileViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddFileViewController.h"

@interface CA_HAddFileViewController ()



@end

@implementation CA_HAddFileViewController

#pragma mark --- Lazy

- (CA_HAddFileViewModel *)viewModel{
    if (!_viewModel) {
        CA_HAddFileViewModel * viewModel = [CA_HAddFileViewModel new];
        
        CA_H_WeakSelf(self);
        viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            
            return self;
        };
        viewModel.backBlock = ^(BOOL isDone) {
            CA_H_StrongSelf(self);
            
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        viewModel.finishCheckBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud:self.view];
            [self.view addSubview:self.viewModel.tableView];
            if (self) {
                self.viewModel.tableView.sd_layout
                .spaceToSuperView(UIEdgeInsetsZero);
            }
        };
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}



#pragma mark --- Custom

//- (void)viewWillAppear:(BOOL)animated {
//    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
//                            offset:CGSizeMake(0, 3)
//                            radius:3
//                             color:CA_H_SHADOWCOLOR
//                           opacity:0.3];
//
//    [super viewWillAppear:animated];
//}

- (void)upView{
    
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItem;
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.viewModel.leftBarButtonItem;
    
    self.title = self.viewModel.title;
    
    [CA_HProgressHUD loading:self.view];
    self.viewModel.checkDirectoryBlock();
    
}

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}


@end
