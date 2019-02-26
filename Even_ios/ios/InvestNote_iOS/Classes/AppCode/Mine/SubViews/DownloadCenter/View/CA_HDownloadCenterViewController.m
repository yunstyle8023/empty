//
//  CA_HDownloadCenterViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadCenterViewController.h"
#import "CA_HDownloadCenterViewManager.h"

#import "CA_HCurrentSearchViewController.h" // 搜索

@interface CA_HDownloadCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HDownloadCenterViewManager *viewManager;

@end

@implementation CA_HDownloadCenterViewController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HDownloadCenterViewModel *)viewModel {
    if (!_viewModel) {
        CA_HDownloadCenterViewModel *viewModel = [CA_HDownloadCenterViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.finishBlock = ^ (BOOL success) {
            CA_H_StrongSelf(self);
            if (success) {
                [self.viewManager.tableView reloadData];
            }
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _viewModel;
}

- (CA_HDownloadCenterViewManager *)viewManager {
    if (!_viewManager) {
        CA_HDownloadCenterViewManager *viewManager = [CA_HDownloadCenterViewManager new];
        _viewManager = viewManager;
        
        CA_H_WeakSelf(self);
        viewManager.onSearchBlock = ^{
            CA_H_StrongSelf(self);
            [self gotoSearch];
        };
        
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated{
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    [super viewWillAppear:animated];
    [self.viewManager.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    self.title = self.viewModel.title;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.viewManager.tableView.delegate = self;
    self.viewManager.tableView.dataSource = self;
    
    [CA_HProgressHUD loading:self.view];
    [self.viewModel loadMore];
}

- (void)gotoSearch {
    
    CA_HCurrentSearchViewController *vc = [CA_HCurrentSearchViewController new];
    vc.viewModel.type = CA_H_SearchTypeDownload;
    vc.viewModel.data = self.viewModel.data;
    vc.viewModel.heightForRowBlock = ^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 65*CA_H_RATIO_WIDTH;
    };
    CA_H_WeakSelf(self);
    CA_H_WeakSelf(vc);
    vc.viewModel.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        CA_H_StrongSelf(self);
        CA_H_StrongSelf(vc);
        CA_HDownloadCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[CA_HDownloadCenterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        CA_H_WeakSelf(self);
        CA_H_WeakSelf(vc);
        cell.editBlock = ^(CA_HBaseTableCell *editCell) {
            CA_H_StrongSelf(self);
            CA_H_StrongSelf(vc);
            [vc.viewManager.titleView resignFirstResponder];
            CA_H_WeakSelf(self);
            CA_H_WeakSelf(vc);
            self.viewManager.menuView.clickBlock = ^(NSInteger item) {
                CA_H_StrongSelf(self);
                CA_H_StrongSelf(vc);
                
                NSDictionary *dic = (id)editCell.model;
                if ([dic[@"type"] integerValue] > 0) {
                    if (item == 0) item = 1;
                }
                
                switch (item) {
                    case 0:
                        [CA_HDownloadCenterViewModel shareFile:dic controller:vc];
                        break;
                    case 1:{
                        NSInteger index = [self.viewModel.data indexOfObject:dic];
                        self.viewModel.data = [CA_HDownloadCenterViewModel deleteItem:index];
                        
                        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:[vc.viewModel.data indexOfObject:dic] inSection:0];
                        
                        NSMutableArray *mut = [NSMutableArray arrayWithArray:vc.viewModel.data];
                        [mut removeObject:dic];
                        vc.viewModel.data = mut;
                        CA_H_WeakSelf(vc);
                        CA_H_DISPATCH_MAIN_THREAD(^{
                            CA_H_StrongSelf(vc);
                            [vc.viewManager.tableView deleteRowAtIndexPath:deleteIndexPath withRowAnimation:UITableViewRowAnimationLeft];
                        });
                    }break;
                    default:
                        break;
                }
                [self.viewManager.menuView hideMenu:YES];
            };
            
            NSDictionary *dic = (id)editCell.model;
            if ([dic[@"type"] integerValue] > 0) {
                self.viewManager.menuView.data = @[@"删除"];
            } else {
                self.viewManager.menuView.data = @[@"发送给朋友",@"删除"];
            }
            
            [CA_H_MANAGER.mainWindow addSubview:self.viewManager.menuView];
            [self.viewManager.menuView showMenu:YES];
        };
        cell.model = vc.viewModel.data[indexPath.row];
        cell.ColorStr = vc.viewModel.searchText;
        
        return cell;
    };
    vc.viewModel.didSelectRowBlock = ^(NSIndexPath *indexPath) {
        CA_H_StrongSelf(vc);
        [CA_HDownloadCenterViewModel browseFile:vc.viewModel.data[indexPath.row] controller:vc];
    };
    
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}

#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *backView = self.viewManager.tableView.backgroundView.subviews.firstObject;
    if (backView.centerX > 0) {
        backView.sd_closeAutoLayout = YES;
        backView.mj_y = -scrollView.contentOffset.y;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView.hidden = (self.viewModel.data.count + self.viewModel.reportData.count);
    if (section) {
        return self.viewModel.data.count;
    }
    return self.viewModel.reportData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CA_HDownloadReportCell *reportCell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
        reportCell.model = self.viewModel.reportData[indexPath.row];
        return reportCell;
    }
    
    
    CA_HDownloadCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CA_H_WeakSelf(self);
    cell.editBlock = ^(CA_HBaseTableCell *editCell) {
        CA_H_StrongSelf(self);
        self.viewManager.menuView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(self);
            NSDictionary *dic = (id)editCell.model;
//            if ([dic[@"type"] integerValue] > 0) {
//                if (item == 0) item = 1;
//            }
            switch (item) {
                case 0:
                    [CA_HDownloadCenterViewModel shareFile:dic controller:self];
                    break;
                case 1:{
                    NSIndexPath *deleteIndexPath = [tableView indexPathForCell:editCell];
                    self.viewModel.data = [CA_HDownloadCenterViewModel deleteItem:deleteIndexPath.row];
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        [self.viewManager.tableView deleteRowAtIndexPath:deleteIndexPath withRowAnimation:UITableViewRowAnimationLeft];
                    });
                }break;
                default:
                    break;
            }
            [self.viewManager.menuView hideMenu:YES];
        };
//        NSDictionary *dic = (id)editCell.model;
//        if ([dic[@"type"] integerValue] > 0) {
//            self.viewManager.menuView.data = @[@"删除"];
//        } else {
//            self.viewManager.menuView.data = @[@"发送给朋友",@"删除"];
//        }
        self.viewManager.menuView.data = @[@"发送给朋友",@"删除"];
        [CA_H_MANAGER.mainWindow addSubview:self.viewManager.menuView];
        [self.viewManager.menuView showMenu:YES];
    };
    cell.model = self.viewModel.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [CA_HDownloadCenterViewModel browseFile:self.viewModel.data[indexPath.row] controller:self];
    }
}

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self shouldBack];
}

- (void)ca_backAction {
    if ([self shouldBack]) {
        [super ca_backAction];
    }
}

- (BOOL)shouldBack {
    
    BOOL set = NO;
    
    for (CA_HDownloadCenterReportModel *model in self.viewModel.reportData) {
        if (model.status.integerValue == 2) {
            set = YES;
            break;
        }
    }
    
    if (set) {
        CA_H_WeakSelf(self);
        [self presentAlertTitle:nil message:CA_H_LAN(@"离开将会中断报告下载，确认离开？") buttons:@[CA_H_LAN(@"再等等"),@[CA_H_LAN(@"确认离开")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index != 0) {
                [super ca_backAction];
            }
        }];
        
        return NO;
    }
    return YES;
}

@end
