//
//  CA_MSettingPanelVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingPanelVC.h"
#import "CA_MSettingPanelViewManager.h"
#import "CA_MSettingPanelViewModel.h"
#import "CA_MSettingPanelDefaultCell.h"
#import "CA_MSettingPanelEditCell.h"
#import "JXMovableCellTableView.h"
#import "CA_MSettingPanelModel.h"

@interface CA_MSettingPanelVC ()

<JXMovableCellTableViewDataSource,
JXMovableCellTableViewDelegate>

@property (nonatomic,strong) CA_MSettingPanelViewManager *viewManager;
@property (nonatomic,strong) CA_MSettingPanelViewModel *viewModel;
@end

@implementation CA_MSettingPanelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewDidDisappear:animated];
}

-(void)upView{
    self.navigationItem.title = self.viewManager.title;
    self.navigationItem.rightBarButtonItem = self.viewManager.rightBarBtn;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark - JXMovableCellTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.viewModel.dataSource firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak CA_MSettingPanelModel *model = [[self.viewModel.dataSource firstObject] objectAtIndex:indexPath.row];
    
    if (model.is_edit) {
        CA_H_WeakSelf(self)
        CA_MSettingPanelEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"SettingPanelEditCell"];
        editCell.model = model;
        editCell.switchBlock = ^(UISwitch *sender) {
            CA_H_StrongSelf(self)
            model.is_show = sender.isOn;
        };
        return editCell;
    }else{
        CA_MSettingPanelDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"SettingPanelDefaultCell"];
        defaultCell.model = model;
        return defaultCell;
    }
    
}

#pragma mark - JXMovableCellTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSMutableArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView{
    return self.viewModel.dataSource;
}

#pragma mark - getter and setter
-(CA_MSettingPanelViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MSettingPanelViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        _viewManager.tableView.gestureMinimumPressDuration = 1.0;
        _viewManager.tableView.drawMovalbeCellBlock = ^(UIView *movableCell){
            movableCell.layer.shadowColor = [UIColor grayColor].CGColor;
            movableCell.layer.masksToBounds = NO;
            movableCell.layer.cornerRadius = 0;
            movableCell.layer.shadowOffset = CGSizeMake(-5, 0);
            movableCell.layer.shadowOpacity = 0.4;
            movableCell.layer.shadowRadius = 5;
        };
        CA_H_WeakSelf(self)
        _viewManager.rightBlock = ^{
            CA_H_StrongSelf(self)
            [self.viewModel editPanelSettingWithData:[self.viewModel.dataSource firstObject] success:^{
                CA_H_StrongSelf(self)
                self.editBlock?self.editBlock():nil;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        };
    }
    return _viewManager;
}

-(CA_MSettingPanelViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MSettingPanelViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}

@end
