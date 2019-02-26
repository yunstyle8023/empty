//
//  CA_HMoveListViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HMoveListViewController.h"

#import "CA_HCurrentSearchViewController.h"

@interface CA_HMoveListViewController ()

@property (nonatomic, strong) CA_HMoveListViewModel * viewModel;
@property (nonatomic, strong) UIViewController *vc;

@end

@implementation CA_HMoveListViewController

#pragma mark --- Lazy

- (CA_HMoveListViewModel *)viewModel{
    if (!_viewModel) {
        CA_HMoveListViewModel *viewModel = [CA_HMoveListViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.onSearchBlock = ^{
            CA_H_StrongSelf(self);
            CA_HCurrentSearchViewController *vc = [CA_HCurrentSearchViewController new];
            self.vc = vc;
            vc.viewModel.type = CA_H_SearchTypeProject;
            CA_H_WeakSelf(self);
            CA_H_WeakSelf(vc);
            vc.viewModel.didSelectRowBlock = ^(NSIndexPath *indexPath) {
                CA_H_StrongSelf(self);
                CA_H_StrongSelf(vc);
                [self.viewModel tableView:vc.viewManager.tableView didSelectRowAtIndexPath:indexPath];
            };
            
            [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
                
            }];
        };
        
        viewModel.alertBlock = ^(CA_MProjectModel *model) {
            CA_H_StrongSelf(self);
            NSString *message = [NSString stringWithFormat:@"确认要将笔记移动至“%@”吗？", model.project_name];
            CA_H_WeakSelf(self);
            [self presentAlertTitle:nil message:message buttons:@[CA_H_LAN(@"再想想"),CA_H_LAN(@"确认")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                if (index == 1) {
                    CA_H_StrongSelf(self);
                    if (self.viewModel.backBlock) {
                        self.viewModel.backBlock(model);
                    }
                } else {
                    [self.viewModel.tableView clearSelectedRowsAnimated:NO];
                    [self.viewModel.tableView reloadData];
                }
            }];
        };
    }
    return _viewModel;
}

- (void)setType:(NSNumber *)type{
    _type = type;
    self.viewModel.type = type.integerValue;
}

- (void)setObjectId:(NSNumber *)objectId {
    _objectId = objectId;
    self.viewModel.defaultSelected = objectId?:@(0);
}

- (void)setNoteTypeBlock:(void (^)(CA_MProjectModel *, CA_HNoteTypeModel *))noteTypeBlock {
    _noteTypeBlock = noteTypeBlock;
    
    CA_H_WeakSelf(self);
    self.viewModel.noteTypeBlock = ^(CA_MProjectModel *model, CA_HNoteTypeModel *typeModel) {
        CA_H_StrongSelf(self);
        if (noteTypeBlock) {
            noteTypeBlock(model, typeModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
        if (self.vc) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
    };
}

- (void)setDoneBlock:(void (^)(NSString *, CA_MProjectModel *, void (^)(void)))doneBlock {
    _doneBlock = doneBlock;
    CA_H_WeakSelf(self);
    self.viewModel.backBlock = ^(CA_MProjectModel *model) {
        CA_H_StrongSelf(self);
        if (doneBlock) {
            CA_H_WeakSelf(self);
            doneBlock(@"project", model, ^{
                CA_H_StrongSelf(self);
                [self.navigationController popViewControllerAnimated:YES];
                if (self.vc) {
                    [self.vc dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }
    };
}

- (void)setBackBlock:(void (^)(CA_MProjectModel *model))backBlock{
    _backBlock = backBlock;
    
    CA_H_WeakSelf(self);
    self.viewModel.backBlock = ^(CA_MProjectModel *model) {
        CA_H_StrongSelf(self);
        if (backBlock) {
            backBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
        if (self.vc) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
    };
}


-(void)setAddBlock:(void (^)(CA_MProjectModel *, NSString *))addBlock{
    _addBlock = addBlock;
    
    CA_H_WeakSelf(self);
    self.viewModel.addBlock = ^(CA_MProjectModel *model, NSString *content) {
        CA_H_StrongSelf(self);
        if (addBlock) {
            addBlock(model,content);
        }
        [self.navigationController popViewControllerAnimated:YES];
        if (self.vc) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
    };
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

- (void)upView{
    
    if ([NSString isValueableString:self.naviTitle]) {
        self.navigationItem.title = self.naviTitle;
    }else{
        self.navigationItem.title = self.viewModel.title;
    }
    
    self.viewModel.hudView = self.view;
    [self.view addSubview:self.viewModel.tableView];
    self.viewModel.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

@end
