//
//  CA_HFoundSearchController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundSearchController.h"

#import "CA_HFoundSearchViewManager.h"

#import "CA_HSearchCollectionViewCell.h"
#import "CA_HBaseTableCell.h"

#import "CA_MDiscoverProjectDetailVC.h"//项目详情
#import "CA_HBusinessDetailsController.h"//企业工商详情
#import "CA_MDiscoverSponsorDetailVC.h"//出资人详情
#import "CA_MDiscoverInvestmentDetailVC.h"//投资机构详情

@interface CA_HFoundSearchController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CA_HFoundSearchViewManager *viewManager;

@end

@implementation CA_HFoundSearchController

#pragma mark --- Action

- (void)onBarButton:(UIButton *)sender {
    [self.viewManager.titleView resignFirstResponder];
    if (self != self.navigationController.viewControllers.firstObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)onClean:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.modelManager cleanSearch];
    } else {
        [self.modelManager cleanBrowse];
    }
    [self.viewManager.collectionView reloadData];
}

#pragma mark --- Lazy

- (CA_HFoundSearchModelManager *)modelManager {
    if (!_modelManager) {
        CA_HFoundSearchModelManager *modelManager = [CA_HFoundSearchModelManager new];
        _modelManager = modelManager;
        
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

- (CA_HFoundSearchViewManager *)viewManager {
    if (!_viewManager) {
        CA_HFoundSearchViewManager *viewManager = [CA_HFoundSearchViewManager new];
        _viewManager = viewManager;
        
        viewManager.titleView.placeholder = self.modelManager.searchHolder;
        viewManager.titleView.delegate = self;
        [viewManager.titleView addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        viewManager.collectionView.delegate = self;
        viewManager.collectionView.dataSource = self;
        
        viewManager.tableView.rowHeight = self.modelManager.rowHeight;
        viewManager.tableView.estimatedRowHeight = self.modelManager.rowHeight;
        
        [viewManager.tableView registerClass:NSClassFromString(self.modelManager.cellClassStr) forCellReuseIdentifier:@"cell"];
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
        
        CA_H_WeakSelf(self);
        viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.modelManager loadMore];
        }];
        
    }
    return _viewManager;
}

- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    self.viewManager.titleView.text = searchText;
    [CA_HProgressHUD loading:self.viewManager.tableView];
    self.modelManager.searchText = searchText;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)pushDetail:(id)dataStr {
    
    UIViewController *vc = nil;
    switch (self.modelManager.type) {
        case CA_HFoundSearchTypeProject:
        {
            CA_MDiscoverProjectDetailVC *projectVC = [CA_MDiscoverProjectDetailVC new];
            vc = projectVC;
            
            projectVC.dataID = dataStr;
        }
            break;
        case CA_HFoundSearchTypeEnterprise:
        {
            CA_HBusinessDetailsController *enterpriseVC = [CA_HBusinessDetailsController new];
            vc = enterpriseVC;
            
            enterpriseVC.modelManager.dataStr = dataStr;
        }
            break;
        case CA_HFoundSearchTypeLp:
        {
            CA_MDiscoverSponsorDetailVC *sponsorDetailVC = [CA_MDiscoverSponsorDetailVC new];
            vc = sponsorDetailVC;
            
            sponsorDetailVC.data_id = dataStr;
        }
            break;
        case CA_HFoundSearchTypeGp:
        {
            CA_MDiscoverInvestmentDetailVC *investmentVC = [CA_MDiscoverInvestmentDetailVC new];
            vc = investmentVC;
            
            investmentVC.data_id = dataStr;
        }
            break;
        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)upConfig {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)upView {
    
    self.navigationItem.rightBarButtonItem = [self.viewManager rightBarButtonItem:self action:@selector(onBarButton:)];
    
    self.navigationItem.titleView = self.viewManager.titleView;
    if (self != self.navigationController.viewControllers.firstObject) {
        self.viewManager.titleView.leftViewMode = UITextFieldViewModeNever;
    }
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    if (!self.searchText.length) {
        [self.viewManager.titleView becomeFirstResponder];
    }
}

#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.viewManager.tableView) {
        [self.viewManager.titleView resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewManager.titleView.text.length > 1) {
        if (self.modelManager.data.count>0) {
            tableView.backgroundView.hidden = YES;
            tableView.mj_footer.hidden = NO;
            return self.modelManager.data.count;
        } else {
            tableView.backgroundView = [self.viewManager tableBackView:self.modelManager.nullText];
        }
    } else {
        tableView.backgroundView = self.viewManager.collectionView;
    }
    tableView.backgroundView.hidden = NO;
    tableView.mj_footer.hidden = YES;
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (self.modelManager.rowHeight > 0) {
//        return self.modelManager.rowHeight;
//    }
//    return [tableView cellHeightForIndexPath:indexPath model:self.modelManager.data[indexPath.row] keyPath:@"model" cellClass:NSClassFromString(self.modelManager.cellClassStr) contentViewWidth:tableView.width];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewManager.titleView.text.length > 1 && self.modelManager.data.count>0) {
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
    
//    if (!(self.modelManager.rowHeight>0)) {
//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HFoundSearchDataModel *model = self.modelManager.data[indexPath.row];
    
    NSDictionary *dic = nil;
    switch (self.modelManager.type) {
        case CA_HFoundSearchTypeProject:
        {
            NSAttributedString *name = model.project_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@""};
        }
            break;
        case CA_HFoundSearchTypeEnterprise:
        {
            NSAttributedString *name = model.enterprise_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":name.string?:@""};
        }
            break;
        case CA_HFoundSearchTypeLp:
        {
            NSAttributedString *name = model.lp_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@""};
        }
            break;
        case CA_HFoundSearchTypeGp:
        {
            NSAttributedString *name = model.gp_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@""};
        }
            break;
        default:
            break;
    }
    
    if (dic) {
        [self.modelManager saveBrowse:dic];
        [self.viewManager.collectionView reloadData];
        
        [self pushDetail:dic[@"id"]];
    }
}


#pragma mark --- Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section) {
        return self.modelManager.recentBrowse.count;
    } else {
        return self.modelManager.recentSearch.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = nil;
    if (indexPath.section) {
        text = self.modelManager.recentBrowse[indexPath.item][@"name"];
    } else {
        text = self.modelManager.recentSearch[indexPath.item];
    }
    CGFloat width = [text widthForFont:CA_H_FONT_PFSC_Regular(14)]+20*CA_H_RATIO_WIDTH;
    return CGSizeMake(MIN(width, (CA_H_SCREEN_WIDTH-40*CA_H_RATIO_WIDTH)), 28*CA_H_RATIO_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    NSArray *data = nil;
    if (section) {
        data = self.modelManager.recentBrowse;
    } else {
        data = self.modelManager.recentSearch;
    }
    
    if (data.count > 0) {
        return CGSizeMake(CA_H_SCREEN_WIDTH, 50*CA_H_RATIO_WIDTH);
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self.viewManager header:indexPath target:self action:@selector(onClean:)];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CA_HSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *text = nil;
    if (indexPath.section) {
        text = self.modelManager.recentBrowse[indexPath.item][@"name"];
    } else {
        text = self.modelManager.recentSearch[indexPath.item];
    }
    cell.label.text = text;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        NSDictionary *dic = self.modelManager.recentBrowse[indexPath.item];
        [self.modelManager saveBrowse:dic];
        [self.viewManager.collectionView reloadData];
        [self pushDetail:dic[@"id"]];
    } else {
        NSString *text = self.modelManager.recentSearch[indexPath.item];
        self.modelManager.searchText = text;
        self.viewManager.titleView.text = text;
        [self.modelManager saveSearch:text];
        [self.viewManager.collectionView reloadData];
    }
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;//[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length > 1) {
        [self.modelManager saveSearch:text];
        [self.viewManager.collectionView reloadData];
    }
}

@end
