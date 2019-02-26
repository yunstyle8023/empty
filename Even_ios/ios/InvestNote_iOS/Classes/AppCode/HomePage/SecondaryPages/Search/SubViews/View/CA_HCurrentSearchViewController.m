//
//  CA_HCurrentSearchViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HCurrentSearchViewController.h"

#import "CA_HHomeSearchFileCell.h"
#import "CA_HHomeSearchProjectCell.h"

#import "CA_HNullView.h"

@interface CA_HCurrentSearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation CA_HCurrentSearchViewController

#pragma mark --- Action

- (void)onBarButton:(UIButton *)sender {
    [self.viewManager.titleView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --- Lazy

- (CA_HCurrentSearchViewModel *)viewModel {
    if (!_viewModel) {
        CA_HCurrentSearchViewModel *viewModel = [CA_HCurrentSearchViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.reloadBlock = ^ (CA_H_RefreshType type) {
            CA_H_StrongSelf(self);
            if (self.viewModel.type == CA_H_SearchTypeProject
                ||
                self.viewModel.type == CA_H_SearchTypeFile) {
                switch (type) {
                    case CA_H_RefreshTypeNomore:
                        [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
                        break;
                    case CA_H_RefreshTypeFirst:
                        [self.viewManager.tableView.mj_footer resetNoMoreData];
                    default:
                        [self.viewManager.tableView.mj_footer endRefreshing];
                        break;
                }
            }
            [self.viewManager.tableView.mj_header endRefreshing];
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self.viewManager.tableView reloadData];
            });
        };
    }
    return _viewModel;
}

- (CA_HCurrentSearchViewManager *)viewManager {
    if (!_viewManager) {
        CA_HCurrentSearchViewManager *viewManager = [CA_HCurrentSearchViewManager new];
        _viewManager = viewManager;
    }
    return  _viewManager;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upConfig];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.viewManager.titleView becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upConfig {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)upView {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];

    self.navigationItem.rightBarButtonItem = [self.viewManager rightBarButtonItem:self action:@selector(onBarButton:)];
    self.viewManager.titleView.delegate = self;
    [self.viewManager.titleView addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = self.viewManager.titleView;
    
    
    NSString *nullTitle = nil;
    switch (self.viewModel.type) {
        case CA_H_SearchTypeFile:
        case CA_H_SearchTypeDownload:
            nullTitle = @"没有搜索到相关文件";
            break;
        case CA_H_SearchTypeProject:
            nullTitle = @"没有搜索到相关项目";
            break;
        default:
            break;
    }
    
    self.viewManager.tableView.backgroundView = [CA_HNullView newTitle:nullTitle buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
    
    self.viewManager.tableView.delegate = self;
    self.viewManager.tableView.dataSource = self;
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    if (self.viewModel.type == CA_H_SearchTypeProject) {
        CA_H_WeakSelf(self);
        self.viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            if (self.viewModel.searchText.length) {
                self.viewModel.projectModel
                .loadMoreBlock(self.viewModel.searchText, YES);
            }
        }];
    } else if (self.viewModel.type == CA_H_SearchTypeFile) {
        CA_H_WeakSelf(self);
        self.viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            if (self.viewModel.searchText.length) {
                [self.viewModel.fileModel loadMore];
            }
        }];
    }
    
    [self.viewManager.titleView becomeFirstResponder];
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView.hidden = (self.viewManager.titleView.text.length<1||self.viewModel.data.count>0);
    tableView.mj_footer.hidden = (self.viewModel.data.count==0);
    return self.viewModel.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.viewModel.type) {
        case CA_H_SearchTypeFile:
        case CA_H_SearchTypeProject:
            return 65*CA_H_RATIO_WIDTH;
        default:
            return self.viewModel.heightForRowBlock(tableView, indexPath);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.viewModel.type) {
        case CA_H_SearchTypeFile:{
            CA_HHomeSearchFileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[CA_HHomeSearchFileCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.model = self.viewModel.data[indexPath.row];
            return cell;
        }
        case CA_H_SearchTypeProject:{
            CA_HHomeSearchProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[CA_HHomeSearchProjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.model = self.viewModel.data[indexPath.row];
            cell.isChoose = YES;
            return cell;
        }
        default:
            return self.viewModel.cellForRowBlock(tableView, indexPath);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.didSelectRowBlock) {
        self.viewModel.didSelectRowBlock(indexPath);
    }
}



#pragma mark --- TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.viewModel.searchText = nil;
    self.viewModel.searchText = textField.text;
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        self.viewModel.searchText = textField.text;
    }
}


@end
