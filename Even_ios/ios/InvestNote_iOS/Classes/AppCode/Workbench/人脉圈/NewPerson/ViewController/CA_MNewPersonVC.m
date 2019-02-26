//
//  CA_MNewPersonVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewPersonVC.h"
#import "CA_MNewPersonViewManager.h"
#import "CA_MNewPersonViewModel.h"
#import "CA_MProjectPersonCell.h"
#import "CA_MSettingType.h"
#import "CA_MSelectItemVC.h"
#import "CA_MAddPersonVC.h"
#import "CA_MChangeWorkSpace.h"
#import "CA_MNewProjectVC.h"
#import "CA_MSelectPersonVC.h"
#import "CA_MProjectSelectResultView.h"
#import "CA_MProjectSearchView.h"
#import "CA_HHomeSearchViewController.h"
#import "CA_MPersonDetailVC.h"
#import "CA_MProjectTagModel.h"

@interface CA_MNewPersonVC ()
<
UITableViewDataSource,
UITableViewDelegate,
CA_MProjectSelectResultViewDelegate,
CA_MProjectSearchViewDelegate>

@property (nonatomic,strong) CA_MNewPersonViewManager *viewManager;
@property (nonatomic,strong) CA_MNewPersonViewModel *viewModel;
@end

@implementation CA_MNewPersonVC

-(void)dealloc{
    [CA_H_NotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    
    [self addNotificationss];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillDisappear:animated];
}


-(void)upView{
    
    self.navigationItem.titleView = self.viewManager.titleViewBtn;
    self.navigationItem.leftBarButtonItem = self.viewManager.leftBarBtn;
    self.navigationItem.rightBarButtonItem = self.viewManager.rightBarBtn;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.view addSubview:self.viewManager.resultView];
    self.viewManager.resultView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50*CA_H_RATIO_WIDTH);
}

-(void)addNotificationss{
    [CA_H_NotificationCenter addObserver:self
                                selector:@selector(refreshWorkbench)
                                    name:CA_M_RefreshHumanListNotification
                                  object:nil];
    
    [CA_H_NotificationCenter addObserver:self
                                selector:@selector(refreshWorkbench)
                                    name:CA_M_RefreshWorkbenchNotification
                                  object:nil];
}

-(void)refreshWorkbench{
    self.viewModel.refreshBlock();
}

#pragma mark - CA_MProjectSelectResultViewDelegate

-(void)cancelClick{
    self.viewManager.resultView.hidden = YES;
    self.viewManager.tableView.tableHeaderView.hidden = NO;
    //
    [self.viewModel.tagList removeAllObjects];
    self.viewModel.refreshBlock();
}

#pragma mark - CA_MProjectSearchViewDelegate

-(void)jump2SearchPage{
    CA_HHomeSearchViewController* searchVC = [[CA_HHomeSearchViewController alloc] init];
    searchVC.buttonTitle = @"人脉";
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        ((UITableView *)scrollView).backgroundView.subviews.firstObject.sd_closeAutoLayout = YES;
        ((UITableView *)scrollView).backgroundView.subviews.firstObject.mj_y = -scrollView.contentOffset.y;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.backgroundView.hidden = self.viewModel.dataSource.count?YES:NO;
//    tableView.mj_footer.hidden = self.viewModel.dataSource.count?NO:YES;
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectPersonCell* personCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectPersonCell"];
    personCell.model = self.viewModel.dataSource[indexPath.row];
    __weak NSIndexPath* weakIndexPath = indexPath;
    CA_H_WeakSelf(self)
    personCell.block = ^{
        CA_H_StrongSelf(self)
        [self tableView:self.viewManager.tableView didSelectRowAtIndexPath:weakIndexPath];
    };
    return personCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MPersonDetailVC* personDetailVC = [[CA_MPersonDetailVC alloc] init];
    CA_MPersonModel* model = self.viewModel.dataSource[indexPath.row];
    personDetailVC.humanID = model.human_id;
    personDetailVC.fileID = model.file_id;
    personDetailVC.filePath = model.file_path;
    [self.navigationController pushViewController:personDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CA_H_WeakSelf(self)
        CA_MPersonModel* model = self.viewModel.dataSource[indexPath.row];
        [self.viewModel deletePersonWithId:model.human_id success:^{
            CA_H_StrongSelf(self)
            [self.viewManager.tableView reloadData];
        }];
    }
}

#pragma mark - getter and setter

-(CA_MNewPersonViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewPersonViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        _viewManager.resultView.delegate = self;
        _viewManager.searchView.delegate = self;
        CA_H_WeakSelf(self)
        _viewManager.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.viewModel.refreshBlock();
        }];
//        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            CA_H_StrongSelf(self);
//            self.viewModel.loadMoreBlock();
//        }];
        _viewManager.leftBlock = ^{
            CA_H_StrongSelf(self)
            CA_MSelectPersonVC* selectPersonVC = [[CA_MSelectPersonVC alloc]initWithShowFrame:CGRectMake(0,Navigation_Height, CA_H_SCREEN_WIDTH, 344*CA_H_RATIO_WIDTH) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(NSArray* array) {
                CA_H_StrongSelf(self)
                
                ((UIButton*)self.viewManager.leftBarBtn.customView).selected = NO;

                if (![NSObject isValueableObject:array]) return ;

                NSMutableString* searchStr = [[NSMutableString alloc] initWithString:@"筛选："];
                [array enumerateObjectsUsingBlock:^(CA_MProjectTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [searchStr appendString:[NSString stringWithFormat:@"%@-",obj.tag_name]];
                    [self.viewModel.tagList addObject:obj.human_tag_id];
                }];
                searchStr = [searchStr substringToIndex:searchStr.length-1].mutableCopy;

                self.viewManager.resultView.title = searchStr;
                self.viewManager.resultView.hidden = NO;
                self.viewManager.tableView.tableHeaderView.hidden = YES;
                //
                self.viewModel.refreshBlock();
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:selectPersonVC animated:YES completion:nil];
            });

        };
        _viewManager.rightBlock = ^{
            CA_H_StrongSelf(self)
            CA_MAddPersonVC* addPersonVC = [[CA_MAddPersonVC alloc] init];
            addPersonVC.naviTitle = @"添加人脉";
            addPersonVC.block = ^(id obj){
                CA_H_StrongSelf(self);
                self.viewModel.refreshBlock();
            };
            [self.navigationController pushViewController:addPersonVC animated:YES];
        };
        _viewManager.titleBlock = ^(UIButton *sender) {
            CA_H_StrongSelf(self)
            CA_MSelectItemVC *selectItemVC = [[CA_MSelectItemVC alloc] initWithShowFrame:CGRectMake(0,Navigation_Height, CA_H_SCREEN_WIDTH, 150*CA_H_RATIO_WIDTH) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id callback) {
                CA_H_StrongSelf(self);
                self.viewManager.titleViewBtn.selected = !self.viewManager.titleViewBtn.isSelected;
            }];
            selectItemVC.currentItemKey = SettingType_HumanResource;
            selectItemVC.block = ^(NSString *itemKey, NSString *item) {
                CA_H_StrongSelf(self);
                if ([itemKey isEqualToString:SettingType_HumanResource]) return ;
                [CA_MChangeWorkSpace replaceWorkSpace:[CA_MNewProjectVC new]];
            };
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:selectItemVC animated:YES completion:nil];
            });
        };
    }
    return _viewManager;
}

-(CA_MNewPersonViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewPersonViewModel new];
        _viewModel.loadingView = self.viewManager.tableView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            [self.viewManager.tableView.mj_header endRefreshing];
            [self.viewManager.tableView reloadData];
        };
    }
    return _viewModel;
}

@end
