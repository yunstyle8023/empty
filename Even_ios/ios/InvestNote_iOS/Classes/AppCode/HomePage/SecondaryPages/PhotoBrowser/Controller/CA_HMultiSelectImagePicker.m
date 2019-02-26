//
//  CA_HMultiSelectImagePicker.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMultiSelectImagePicker.h"

#import "CA_HMultiSelectViewModel.h"

@interface CA_HMultiSelectImagePicker ()

@property (nonatomic, strong) CA_HMultiSelectViewModel * viewModel;

@end

@implementation CA_HMultiSelectImagePicker

#pragma mark --- Lazy

- (CA_HMultiSelectViewModel *)viewModel{
    if (!_viewModel) {
        CA_HMultiSelectViewModel * viewModel = [CA_HMultiSelectViewModel new];
        
        CA_H_WeakSelf(self);
        
        viewModel.getControllerBlock = ^UIViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
        
        viewModel.backBlock = ^(BOOL isNext) {
            CA_H_StrongSelf(self);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic, BOOL animated) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:animated];
        };
        
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (void)setMaxSelected:(NSUInteger)maxSelected{
    _maxSelected = maxSelected;
    self.viewModel.maxSelected = maxSelected;
}

#pragma mark --- LifeCircle

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.collectionView reloadData];
}

#pragma mark --- Custom

- (void)upView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.viewModel.titleView;
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.viewModel.leftBarButtonItem;
    
    
    [self.view addSubview:self.viewModel.collectionView];
    self.viewModel.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 48*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 0));
    
    [self.view addSubview:self.viewModel.originalButton];
    self.viewModel.originalButton.sd_layout
    .heightIs(40*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.view, 5*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.view, 4*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    [self.viewModel.originalButton setupAutoWidthWithRightView:self.viewModel.originalButton.titleLabel rightMargin:10*CA_H_RATIO_WIDTH];
}

@end
