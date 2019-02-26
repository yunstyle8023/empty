//
//  CA_HSearchReportController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSearchReportController.h"

#import "CA_HSearchReportModelManager.h"
#import "CA_HSearchReportViewManager.h"

#import "CA_HBaseTableCell.h"

#import "CA_HBorwseFileManager.h"//浏览

@interface CA_HSearchReportController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HSearchReportModelManager *modelManager;
@property (nonatomic, strong) CA_HSearchReportViewManager *viewManager;

@end

@implementation CA_HSearchReportController

#pragma mark --- Action

- (void)onBarButton:(UIButton *)sender {
    [self.viewManager.titleView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --- Lazy

- (CA_HSearchReportModelManager *)modelManager {
    if (!_modelManager) {
        CA_HSearchReportModelManager *modelManager = [CA_HSearchReportModelManager new];
        _modelManager = modelManager;
        
        modelManager.dataType = @"qcc_report";
        CA_H_WeakSelf(self);
        modelManager.finishBlock = ^(BOOL noMore) {
            CA_H_StrongSelf(self);
            if (noMore) {
                [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.viewManager.tableView.mj_footer endRefreshing];
            }
            if (self.modelManager.model.page_num.integerValue == 1) {
                [self.viewManager.tableView setContentOffset:CGPointZero];
            }
            [self.viewManager.tableView reloadData];
            [CA_HProgressHUD hideHud:self.viewManager.tableView];
        };
    }
    return _modelManager;
}

- (CA_HSearchReportViewManager *)viewManager {
    if (!_viewManager) {
        CA_HSearchReportViewManager *viewManager = [CA_HSearchReportViewManager new];
        _viewManager = viewManager;
        
        CA_H_WeakSelf(self);
        viewManager.chooseBlock = ^(NSInteger item) {
            CA_H_StrongSelf(self);
            if (item) {
                self.modelManager.dataType = @"qk_report";
            } else {
                self.modelManager.dataType = @"qcc_report";
            }
            
            NSString *text = self.modelManager.searchText;
            self.modelManager.searchText = nil;
            [CA_HProgressHUD loading:self.viewManager.tableView];
            self.modelManager.searchText = text;
        };

        viewManager.titleView.delegate = self;
        [viewManager.titleView addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore:@(self.modelManager.model.page_num.integerValue+1)];
        }];
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
        
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upConfig];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
    [self.viewManager.tableView reloadData];
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
    
    self.navigationItem.rightBarButtonItem = [self.viewManager rightBarButtonItem:self action:@selector(onBarButton:)];
    
    self.navigationItem.titleView = self.viewManager.titleView;
    
    [self.view addSubview:self.viewManager.buttonView];
    self.viewManager.buttonView.sd_layout
    .heightIs(36*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.view, 15*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.view, 20*CA_H_RATIO_WIDTH);
    self.viewManager.buttonView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(51*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    [self.viewManager.titleView becomeFirstResponder];
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView.hidden =  (self.viewManager.titleView.text.length<2||self.modelManager.data.count>0);
    tableView.mj_footer.hidden = !(self.modelManager.data.count>0);
    return self.modelManager.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.modelManager.data.count>0) {
        return 44*CA_H_RATIO_WIDTH;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.viewManager searchHeader:self.modelManager.headerText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.model = self.modelManager.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HFoundReportData *model = self.modelManager.data[indexPath.row];
    
    [CA_HBorwseFileManager browseReport:model controller:self];
}

#pragma mark --- TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length < 2) {
        [CA_HProgressHUD showHudStr:@"请至少输入两个字符"];
    }
    self.modelManager.searchText = textField.text;//[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        self.modelManager.searchText = textField.text;//[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (text.length > 1) {
//
//    }
//}

@end
