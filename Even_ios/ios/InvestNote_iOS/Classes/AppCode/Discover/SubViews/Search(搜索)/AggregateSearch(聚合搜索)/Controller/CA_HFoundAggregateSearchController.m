//
//  CA_HFoundAggregateSearchController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundAggregateSearchController.h"

#import "CA_HFoundAggregateSearchModelManager.h"
#import "CA_HFoundAggregateSearchViewManager.h"

#import "CA_HFoundSearchController.h"

#import "CA_HSearchCollectionViewCell.h"
#import "CA_HBaseTableCell.h"

#import "CA_MDiscoverProjectDetailVC.h"//项目详情
#import "CA_HBusinessDetailsController.h"//企业工商详情
#import "CA_MDiscoverSponsorDetailVC.h"//出资人详情
#import "CA_MDiscoverInvestmentDetailVC.h"//投资机构详情


@interface CA_HFoundAggregateSearchController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CA_HFoundAggregateSearchModelManager *modelManager;
@property (nonatomic, strong) CA_HFoundAggregateSearchViewManager *viewManager;

@end

@implementation CA_HFoundAggregateSearchController


#pragma mark --- Action

- (void)onBarButton:(UIButton *)sender {
    [self.viewManager.titleView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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

- (CA_HFoundAggregateSearchModelManager *)modelManager {
    if (!_modelManager) {
        CA_HFoundAggregateSearchModelManager *modelManager = [CA_HFoundAggregateSearchModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.finishBlock = ^ {
            CA_H_StrongSelf(self);
//            [self.viewManager.tableView setContentOffset:CGPointZero];
            [self.viewManager.tableView reloadData];
        };
    }
    return _modelManager;
}

- (CA_HFoundAggregateSearchViewManager *)viewManager {
    if (!_viewManager) {
        CA_HFoundAggregateSearchViewManager *viewManager = [CA_HFoundAggregateSearchViewManager new];
        _viewManager = viewManager;
        
        viewManager.titleView.delegate = self;
        [viewManager.titleView addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        viewManager.collectionView.delegate = self;
        viewManager.collectionView.dataSource = self;
        
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
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.viewManager.titleView becomeFirstResponder];
}

- (void)pushDetail:(id)dataStr type:(NSInteger)type{
    
    UIViewController *vc = nil;
    switch (type) {
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

#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.viewManager.tableView) {
        [self.viewManager.titleView resignFirstResponder];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.modelManager.model) {
        if ([self.modelManager data:0].count+[self.modelManager data:1].count+[self.modelManager data:2].count+[self.modelManager data:3].count>0) {
            tableView.backgroundView.hidden = YES;
            return 4;
        } else {
            tableView.backgroundView = self.viewManager.nullView;
            tableView.backgroundView.hidden = NO;
            return 0;
        }
    } else {
        tableView.backgroundView = self.viewManager.collectionView;
        tableView.backgroundView.hidden = NO;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelManager data:section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1:
            return 66*CA_H_RATIO_WIDTH;
        case 2:
            return 90*CA_H_RATIO_WIDTH;
        case 3:
            return 116*CA_H_RATIO_WIDTH;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.modelManager data:section].count > 0) {
        return 51*CA_H_RATIO_WIDTH;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.modelManager data:section].count < 3) {
        return 0;
    }
    return 50*CA_H_RATIO_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text = [NSString stringWithFormat:@"%@（%@）", [self.modelManager headerTitle:section], [self.modelManager count:section]];
    return [self.viewManager searchHeader:text];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *text = [NSString stringWithFormat:@"查看更多%@", [self.modelManager headerTitle:section]];
    CA_H_WeakSelf(self);
    UITableViewHeaderFooterView *footer = [self.viewManager searchFooter:text ActionBlock:^(id sender) {
        CA_H_StrongSelf(self);
        [self.viewManager.titleView resignFirstResponder];
        CA_HFoundSearchController *searchVC = [CA_HFoundSearchController new];
        searchVC.modelManager.type = [sender view].superview.tag-100;
        searchVC.searchText = self.modelManager.searchText;
        [self.navigationController pushViewController:searchVC animated:YES];
    }];
    footer.contentView.tag = 100+section;
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", indexPath.section];
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.model = [self.modelManager data:indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HBaseTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CA_HFoundSearchDataModel *model = (id)cell.model;
    
    NSDictionary *dic = nil;
    switch (indexPath.section) {
        case CA_HFoundSearchTypeProject:
        {
            NSAttributedString *name = model.project_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@"",
                    @"type":@(indexPath.section)};
        }
            break;
        case CA_HFoundSearchTypeEnterprise:
        {
            NSAttributedString *name = model.enterprise_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":name.string?:@"",
                    @"type":@(indexPath.section)};
        }
            break;
        case CA_HFoundSearchTypeLp:
        {
            NSAttributedString *name = model.lp_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@"",
                    @"type":@(indexPath.section)};
        }
            break;
        case CA_HFoundSearchTypeGp:
        {
            NSAttributedString *name = model.gp_name_attributedText;
            dic = @{@"name":name.string?:@"",
                    @"id":model.data_id?:@"",
                    @"type":@(indexPath.section)};
        }
            break;
        default:
            break;
    }
    
    if (dic) {
        [self.modelManager saveBrowse:dic];
        [self.viewManager.collectionView reloadData];
        
        [self pushDetail:dic[@"id"] type:[dic[@"type"] integerValue]];
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
        [self pushDetail:dic[@"id"] type:[dic[@"type"] integerValue]];
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
