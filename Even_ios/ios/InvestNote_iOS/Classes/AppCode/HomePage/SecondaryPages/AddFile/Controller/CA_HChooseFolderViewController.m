//
//  CA_HChooseFolderViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HChooseFolderViewController.h"

#import "CA_HChooseFolderViewModel.h"

@interface CA_HChooseFolderViewController ()

@property (nonatomic, strong) CA_HChooseFolderViewModel * viewModel;

@end

@implementation CA_HChooseFolderViewController

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
            CA_HChooseFolderViewController * vc = [NSClassFromString(classStr) new];
            vc.title = parentModel.file_name;
            vc.viewModel.parentModel = parentModel;
            vc.chooseBlock = self.chooseBlock;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        viewModel.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud:self.view];
            if (success) {
                [self customScrollView];
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
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
}

- (void)upView{
    self.title = self.viewModel.title;
    
    [CA_HProgressHUD loading:self.view];
}

- (void)ca_layoutContentView{
    [super ca_layoutContentView];

    self.viewModel.loadDataBlock();
}

// 滚动分页
- (NSArray *)scrollViewTitles {
    return self.viewModel.titles;
}
- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    return [self.viewModel fileListView:item];
}

@end
