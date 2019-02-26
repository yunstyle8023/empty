//
//  CA_HChooseParticipantsViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HChooseParticipantsViewController.h"

@interface CA_HChooseParticipantsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CA_HChooseParticipantsViewController

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    
    self.viewModel.onButtonBlock(!sender||sender.tag == 101);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --- Lazy

- (CA_HChooseParticipantsViewModel *)viewModel {
    if (!_viewModel) {
        CA_HChooseParticipantsViewModel *viewModel = [CA_HChooseParticipantsViewModel new];
        _viewModel = viewModel;
        
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = self.viewModel.tableViewBlock(self);
    }
    return _tableView;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
    if (!self.viewModel.isAll) {
        self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItemBlock(self, @selector(onButton:));
    }
    self.navigationItem.leftBarButtonItem = self.viewModel.leftBarButtonItemBlock(self, @selector(onButton:));
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.data.count) {
        return self.viewModel.data.count+self.viewModel.isAll;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.cellForRowBlock(tableView, indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isAll) {
        [self onButton:nil];
    } else {
        self.viewModel.changeRightBarBlock(self.navigationItem.rightBarButtonItem.customView);
    }
}



@end
