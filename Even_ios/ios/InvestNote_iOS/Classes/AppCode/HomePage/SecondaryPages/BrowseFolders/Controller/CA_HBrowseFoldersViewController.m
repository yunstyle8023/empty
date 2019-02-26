//
//  CA_HBrowseFoldersViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/26.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBrowseFoldersViewController.h"

// 搜索
#import "CA_HCurrentSearchViewController.h"
#import "CA_HBorwseFileManager.h"

@interface CA_HBrowseFoldersViewController ()

@end

@implementation CA_HBrowseFoldersViewController

#pragma mark --- Action

- (void)ca_backAction {
    if (self.viewModel.updateFileManager.contents.count > 0) {
        CA_H_WeakSelf(self);
        [self presentAlertTitle:nil message:CA_H_LAN(@"当前有文件正在上传中，离开将会中断上传，确认离开？") buttons:@[CA_H_LAN(@"再等等"),@[CA_H_LAN(@"确认离开")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- Lazy

- (CA_HBrowseFoldersViewModel *)viewModel{
    if (!_viewModel) {
        CA_HBrowseFoldersViewModel * viewModel = [CA_HBrowseFoldersViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
        
        viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        viewModel.onSearchBlock = ^{
            CA_H_StrongSelf(self);
            CA_HCurrentSearchViewController *vc = [CA_HCurrentSearchViewController new];
            vc.viewModel.parentPath = self.viewModel.model.file_path;
            vc.viewModel.type = CA_H_SearchTypeFile;
            CA_H_WeakSelf(self);
            CA_H_WeakSelf(vc);
            vc.viewModel.didSelectRowBlock = ^(NSIndexPath *indexPath) {
                CA_H_StrongSelf(self);
                CA_H_StrongSelf(vc);
                CA_HBrowseFoldersModel *model = vc.viewModel.data[indexPath.row];
                
                NSString *fileName = model.file_path.lastObject;
                if ([model.file_type isEqualToString:@"directory"]) {
                    CA_HBrowseFoldersViewController *fvc = [CA_HBrowseFoldersViewController new];
                    model.file_name = fileName;
                    fvc.model = model;
                    [self.navigationController pushViewController:fvc animated:YES];
                    [vc dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [CA_HBorwseFileManager browseCachesFile:model.file_id fileName:fileName fileUrl:model.storage_path controller:vc];
                }
            };
            
            [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
                
            }];
        };
    }
    return _viewModel;
}
- (void)setModel:(CA_HBrowseFoldersModel *)model {
    self.title = model.file_name;
    self.viewModel.model = model;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
    [super viewWillAppear:animated];
}

#pragma mark --- Custom

- (void)upView{
    self.navigationItem.rightBarButtonItem = self.viewModel.rightNavBarButton;
    [self.view addSubview:self.viewModel.tableView];
    self.viewModel.tableView
    .sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [CA_HProgressHUD loading:self.view];
    
    NSArray *array = self.viewModel.model.file_path;
    self.viewModel.listFileModel.loadDataBlock(array, nil);
}

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewModel.updateFileManager.contents.count == 0;
}

@end
