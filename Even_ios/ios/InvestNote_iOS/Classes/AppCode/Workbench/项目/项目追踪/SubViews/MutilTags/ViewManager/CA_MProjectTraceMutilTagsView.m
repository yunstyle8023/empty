//
//  CA_MProjectTraceMutilTagsView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceMutilTagsView.h"
#import "CA_MProjectTraceMutilTagsViewModel.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MProjectTraceRelatedCell.h"
#import "CA_MProjectTraceMutilTModel.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverProjectDetailTagVC.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MEmptyView.h"

@interface CA_MProjectTraceMutilTagsView ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MEmptyView *emptyView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) CA_MProjectTraceMutilTagsViewModel *viewModel;

@property (nonatomic,assign) TraceCellType traceCellType;

@end

@implementation CA_MProjectTraceMutilTagsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return self;
}

-(void)configView:(NSNumber *)project_id
          tagName:(NSString *)tagName
    traceCellType:(TraceCellType)traceCellType{
    
    self.traceCellType = traceCellType;
    
    if (!self.viewModel.isFinished) {
        self.viewModel.project_id = project_id;
        self.viewModel.requestModel.tag_name = tagName;
        self.viewModel.loadDataBlock();
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    self.emptyView.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    self.tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CA_HBaseTableCell *cell;
    CA_MDiscoverCompatible_project_list *model = self.viewModel.dataSource[indexPath.row];
    if (self.traceCellType == TraceType_Tag) {
        CA_MDiscoverProjectDetailRelatedProductCell *relatedProductCel = [tableView dequeueReusableCellWithIdentifier:@"RelatedProductCell"];
        cell = relatedProductCel;
        relatedProductCel.model = model;
        CA_H_WeakSelf(self)
        relatedProductCel.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectDetailTagVC *tagVC = [CA_MDiscoverProjectDetailTagVC new];
            tagVC.tagName = tagName;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [[self currentViewController].navigationController pushViewController:tagVC animated:YES];
            });
        };
    }else if (self.traceCellType == TraceType_Normal) {
        CA_MProjectTraceRelatedCell *relatedCell = [tableView dequeueReusableCellWithIdentifier:@"RelatedCell"];
        cell = relatedCell;
        relatedCell.model = model;
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

#pragma mark -  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MDiscoverCompatible_project_list *model = self.viewModel.dataSource[indexPath.row];
    CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
    projectDetailVC.dataID = model.data_id;
    CA_H_DISPATCH_MAIN_THREAD(^{
        [[self currentViewController].navigationController pushViewController:projectDetailVC animated:YES];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.traceCellType == TraceType_Tag) {
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailRelatedProductCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if (self.traceCellType == TraceType_Normal) {
        return [tableView cellHeightForIndexPath:indexPath model:self.viewModel.dataSource[indexPath.row] keyPath:@"model" cellClass:[CA_MProjectTraceRelatedCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

-(CA_MProjectTraceMutilTagsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MProjectTraceMutilTagsViewModel new];
        _viewModel.loadingView = self.tableView;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasMore){
            CA_H_StrongSelf(self)
            
            self.emptyView.hidden = [NSObject isValueableObject:self.viewModel.dataSource];
            
            if (isHasMore) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

            [self.tableView.mj_header endRefreshing];

            [self.tableView reloadData];
        };
    }
    return _viewModel;
}

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [CA_MEmptyView newTitle:@"当前您还没有参与任何项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_project"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = self.emptyView;
        CA_H_WeakSelf(self)
        _tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock();
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.loadMoreBlock();
        }];
        _tableView.mj_footer.hidden = YES;

        [_tableView registerClass:[CA_MProjectTraceRelatedCell class] forCellReuseIdentifier:@"RelatedCell"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailRelatedProductCell class] forCellReuseIdentifier:@"RelatedProductCell"];
    }
    return _tableView;
}

@end
