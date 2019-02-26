//
//  CA_HChooseFolderListViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/21.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HChooseFolderListViewController.h"

#import "CA_HChooseFolderViewModel.h"

@interface CA_HChooseFolderListViewController ()

@property (nonatomic, strong) CA_HChooseFolderViewModel * viewModel;
@property (nonatomic, assign) BOOL isfirst;

@end

@implementation CA_HChooseFolderListViewController

#pragma mark --- lazy

- (CA_HChooseFolderViewModel *)viewModel{
    if (!_viewModel) {
        CA_HChooseFolderViewModel * viewModel = [CA_HChooseFolderViewModel new];
        
        CA_H_WeakSelf(self);
        viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
        
        viewModel.chooseBlock = ^(CA_HBrowseFoldersModel *parentModel) {
            CA_H_StrongSelf(self);
            if (self.chooseBlock) {
                [self.navigationController popToViewController:self.chooseBlock(parentModel) animated:YES];
            }
        };
        
        viewModel.pushBlock = ^(NSString *classStr,  CA_HBrowseFoldersModel *parentModel) {
            CA_H_StrongSelf(self);
            CA_HChooseFolderListViewController * vc = [NSClassFromString(classStr) new];
            vc.title = parentModel.file_name;
            vc.viewModel.parentModel = parentModel;
            vc.chooseBlock = self.chooseBlock;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        viewModel.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud:self.view];
            if (success) {
                if (self.isfirst) {
                    [self upView];
                }
            }
        };
        
        _viewModel = viewModel;
    }
    return _viewModel;
}




#pragma mark --- lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isfirst = YES;
    [CA_HProgressHUD loading:self.view];
    self.viewModel.loadDataBlock();
}

#pragma mark --- Custom

- (void)upView{
    _isfirst = NO;
    UIView * view = [self.viewModel fileListView:0];
    [self.view addSubview:view];
    view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}


@end
