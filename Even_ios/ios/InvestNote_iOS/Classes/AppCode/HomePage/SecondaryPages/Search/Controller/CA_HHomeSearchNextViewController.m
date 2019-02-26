//
//  CA_HHomeSearchNextViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/29.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchNextViewController.h"

#import "CA_HHomeSearchViewModel.h"

@interface CA_HHomeSearchNextViewController ()

@property (nonatomic, strong) CA_HHomeSearchViewModel * viewModel;

@end

@implementation CA_HHomeSearchNextViewController

#pragma mark --- Lazy

- (CA_HHomeSearchViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_HHomeSearchViewModel new];
        
        CA_H_WeakSelf(self);
        _viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
//        _viewModel.backBlock = ^{
//            CA_H_StrongSelf(self);
//            [self.navigationController popViewControllerAnimated:YES];
//        };
        _viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _viewModel;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.viewModel.data removeAllObjects];
    [self.viewModel.data addObject:dataDic];
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)upView{
    
    [self.view addSubview:self.viewModel.tableView];
    self.viewModel.tableView
    .sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}


@end
