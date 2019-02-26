//
//  CA_MProjectTraceTableView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceTableView.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MProjectInvestDynamicCell.h"
#import "CA_MProjectInvestRelevanceCell.h"
#import "CA_MProjectNoTraceCell.h"
#import "CA_MDiscoverProjectDetailSectionHeaderView.h"
#import "CA_MDiscoverProjectDetailSectionFooterView.h"
#import "CA_MProjectTraceViewModel.h"
#import "CA_MNavigationController.h"
#import "CA_MNewSearchProjectVC.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MProjectTraceInvestedModel.h"
#import "CA_MDiscoverProjectH5VC.h"
#import "CA_MDiscoverProjectDetailVC.h"
#import "CA_MDiscoverInvestmentDetailVC.h"
#import "CA_MProjectTraceDynamicVC.h"
#import "CA_MProjectTraceMutilTagsVC.h"
#import "CA_MDiscoverProjectDetailTagVC.h"
#import "CA_MEmptyView.h"
#import "ButtonLabel.h"


@interface CA_MProjectTraceTableView ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MProjectTraceViewModel *viewModel;

@property (nonatomic,strong) NSNumber *project_id;

@property (nonatomic,assign,getter=isRelation) BOOL relation;

@property (nonatomic,strong) CA_MEmptyView *emptyView;

@end

@implementation CA_MProjectTraceTableView

-(void)dealloc{
    [CA_H_NotificationCenter removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[CA_MDiscoverProjectDetailRelatedProductCell class] forCellReuseIdentifier:@"RelatedProductCell"];
        [self registerClass:[CA_MDiscoverProjectDetailNewsCell class] forCellReuseIdentifier:@"NewsCell"];
        [self registerClass:[CA_MProjectInvestDynamicCell class] forCellReuseIdentifier:@"DynamicCell"];
        [self registerClass:[CA_MProjectInvestRelevanceCell class] forCellReuseIdentifier:@"RelevanceCell"];
        [self registerClass:[CA_MProjectNoTraceCell class] forCellReuseIdentifier:@"NoTraceCell"];

        [CA_H_NotificationCenter addObserver:self selector:@selector(relationSuccess) name:@"RelationSuccess" object:nil];
        
        self.backgroundView = ({
            UIView *backView = [UIView new];
            [backView addSubview:self.emptyView];
            self.emptyView.sd_layout
            .spaceToSuperView(UIEdgeInsetsZero);
            backView;
        });

        self.relation = NO;
        
        CA_H_WeakSelf(self)
        self.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.refreshBlock(self.project_id);
        }];
    }
    return self;
}

-(void)relationSuccess{
    self.relation = YES;
    self.viewModel.refreshBlock(self.project_id);
}

-(void (^)(NSNumber *,BOOL, NSNumber *))loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(NSNumber *member_type_id,BOOL is_relation,NSNumber *project_id){
        CA_H_StrongSelf(self)
        
        self.project_id = project_id;
        self.viewModel.loadDataBlock(project_id);
        
        if (member_type_id.intValue == 0) {//成员不显示添加按钮
            [self.emptyView updateTitle:@"暂未关联项目" buttonTitle:@"" imageName:@"empty_project"];
        }
        
    };
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIView *backView = self.backgroundView.subviews.firstObject;
    if (backView.centerX > 0) {
        backView.sd_closeAutoLayout = YES;
        backView.mj_y = -self.contentOffset.y;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.data_list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [self.viewModel.data_list[section][@"track_list"] count];
    NSString *track_type = self.viewModel.data_list[section][@"track_type"];
    if (![track_type isEqualToString:@"relevance_project"]) {
        return (count==0?1:count);
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    NSString *track_type = self.viewModel.data_list[indexPath.section][@"track_type"];
    NSArray *track_list = self.viewModel.data_list[indexPath.section][@"track_list"];
    NSArray *track_name = self.viewModel.data_list[indexPath.section][@"track_name"];
    if (![track_type isEqualToString:@"relevance_project"]) {
        if (![NSObject isValueableObject:track_list]) {
            CA_MProjectNoTraceCell *noTraceCell = [tableView dequeueReusableCellWithIdentifier:@"NoTraceCell"];
            noTraceCell.messageLb.text = [NSString stringWithFormat:@"暂无%@",track_name];
            return noTraceCell;
        }
    }
    
    if([track_type isEqualToString:@"project_product"]){//相关竟品
        CA_MDiscoverProjectDetailRelatedProductCell *relatedProductCell = [tableView dequeueReusableCellWithIdentifier:@"RelatedProductCell"];
        relatedProductCell.lineView.hidden = YES;
        cell = relatedProductCell;
        NSDictionary *dic = track_list[indexPath.row];
        CA_MDiscoverCompatible_project_list *model = [CA_MDiscoverCompatible_project_list modelWithDictionary:dic];
        relatedProductCell.model = model;
        CA_H_WeakSelf(self)
        relatedProductCell.pushBlock = ^(NSIndexPath *indexPath, NSString *tagName) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectDetailTagVC *tagVC = [CA_MDiscoverProjectDetailTagVC new];
            tagVC.tagName = tagName;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [[self currentViewController].navigationController pushViewController:tagVC animated:YES];
            });
        };
        return relatedProductCell;
    }else if ([track_type isEqualToString:@"project_dynamic"] ||//项目动态
              [track_type isEqualToString:@"product_dynamic"]) {//竟品动态
        CA_MDiscoverProjectDetailNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        newsCell.lineView.hidden = YES;
        cell = newsCell;
        NSDictionary *dic = track_list[indexPath.row];
        CA_MDiscoverNews_list *model = [CA_MDiscoverNews_list modelWithDictionary:dic];
        newsCell.model = model;
        return newsCell;
    }else if ([track_type isEqualToString:@"investor_dynamic"]) {//投资方动态
        CA_MProjectInvestDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
        cell = dynamicCell;
        NSDictionary *dic = track_list[indexPath.row];
        CA_MProjectTraceInvestedModel *model = [CA_MProjectTraceInvestedModel modelWithDictionary:dic];
        dynamicCell.model = model;
        CA_H_WeakSelf(self)
        __weak CA_MProjectTraceInvestedModel*weakModel = model;
        dynamicCell.investorLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverInvestmentDetailVC *investmentVC = [CA_MDiscoverInvestmentDetailVC new];
            investmentVC.data_id = weakModel.investor_id;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [[self currentViewController].navigationController pushViewController:investmentVC animated:YES];
            });
        };
        dynamicCell.investoredLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
            projectDetailVC.dataID = weakModel.invested_id;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [[self currentViewController].navigationController pushViewController:projectDetailVC animated:YES];
            });
        };
        dynamicCell.newsLb.didSelect = ^(ButtonLabel *sender) {
            CA_H_StrongSelf(self)
            CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
            h5VC.urlStr = weakModel.news_url;
            CA_H_DISPATCH_MAIN_THREAD(^{
                [[self currentViewController].navigationController pushViewController:h5VC animated:YES];
            });
        };
        return dynamicCell;
        
    }else if ([track_type isEqualToString:@"relevance_project"]) {
        CA_H_WeakSelf(self)
        CA_MProjectInvestRelevanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelevanceCell"];
        cell.closeBlock = ^{
            CA_H_StrongSelf(self)
            
            if ([[[self.viewModel.data_list firstObject] valueForKey:@"track_type"] isEqualToString:@"relevance_project"]) {
                [self.viewModel.data_list removeObjectAtIndex:0];
            }

            CA_H_DISPATCH_MAIN_THREAD(^{
                [self reloadData];
            });
        };
        return cell;
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *track_type = self.viewModel.data_list[indexPath.section][@"track_type"];
    NSArray *track_list = self.viewModel.data_list[indexPath.section][@"track_list"];
    
    if (![track_type isEqualToString:@"relevance_project"]) {
        if (![NSObject isValueableObject:track_list]) {
            return;
        }
    }
    
    NSDictionary *dic = track_list[indexPath.row];
    if([track_type isEqualToString:@"project_product"]){//相关竟品
        CA_MDiscoverProjectDetailVC *projectDetailVC = [CA_MDiscoverProjectDetailVC new];
        projectDetailVC.dataID = dic[@"data_id"];
        CA_H_DISPATCH_MAIN_THREAD(^{
            [[self currentViewController].navigationController pushViewController:projectDetailVC animated:YES];
        });
    }else if ([track_type isEqualToString:@"project_dynamic"] ||//项目动态
              [track_type isEqualToString:@"product_dynamic"]) {//竟品动态
        
        CA_MDiscoverProjectH5VC *h5VC = [CA_MDiscoverProjectH5VC new];
//        h5VC.navigationItem.title = dic[@"news_title"];
        h5VC.urlStr = dic[@"news_url"];
        CA_H_DISPATCH_MAIN_THREAD(^{
            [[self currentViewController].navigationController pushViewController:h5VC animated:YES];
        });
    }else if ([track_type isEqualToString:@"investor_dynamic"]) {//投资方动态
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *track_type = self.viewModel.data_list[indexPath.section][@"track_type"];
    NSArray *track_list = self.viewModel.data_list[indexPath.section][@"track_list"];
    
    if (![track_type isEqualToString:@"relevance_project"]) {
        if (![NSObject isValueableObject:track_list]) {
            return 50*2*CA_H_RATIO_WIDTH;
        }
    }
    
    if([track_type isEqualToString:@"project_product"]){//相关竟品
        NSDictionary *dic = track_list[indexPath.row];
        CA_MDiscoverCompatible_project_list *model = [CA_MDiscoverCompatible_project_list modelWithDictionary:dic];
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailRelatedProductCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if ([track_type isEqualToString:@"project_dynamic"] ||//项目动态
              [track_type isEqualToString:@"product_dynamic"]) {//竟品动态
        NSDictionary *dic = track_list[indexPath.row];
        CA_MDiscoverNews_list *model = [CA_MDiscoverNews_list modelWithDictionary:dic];
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_MDiscoverProjectDetailNewsCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if ([track_type isEqualToString:@"investor_dynamic"]) {//投资方动态
        NSDictionary *dic = track_list[indexPath.row];
        CA_MProjectTraceInvestedModel *model = [CA_MProjectTraceInvestedModel modelWithDictionary:dic];
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_MProjectInvestDynamicCell class] contentViewWidth:CA_H_SCREEN_WIDTH];
    }else if ([track_type isEqualToString:@"relevance_project"]) {//relevance_project
        return 28*2*CA_H_RATIO_WIDTH;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *track_type = self.viewModel.data_list[section][@"track_type"];
    
    if (![track_type isEqualToString:@"relevance_project"]) {
        CA_MDiscoverProjectDetailSectionHeaderView *sectionView = [CA_MDiscoverProjectDetailSectionHeaderView new];
        sectionView.title = [NSString stringWithFormat:@"%@ （%@）",self.viewModel.data_list[section][@"track_name"],self.viewModel.data_list[section][@"total_count"]];
        
        if ([self.viewModel.data_list[0][@"track_type"] isEqualToString:@"relevance_project"]) {
            sectionView.lineView.hidden = YES;
        }else {
            sectionView.lineView.hidden = section==0?YES:NO;
        }
        return sectionView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *track_type = self.viewModel.data_list[section][@"track_type"];
    
    if (![track_type isEqualToString:@"relevance_project"]) {
        return 27*2*CA_H_RATIO_WIDTH;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSInteger total_count = [self.viewModel.data_list[section][@"total_count"] integerValue];
    NSString *track_type = self.viewModel.data_list[section][@"track_type"];
    if (total_count > 3) {
        CA_MDiscoverProjectDetailSectionFooterView *footerView = [CA_MDiscoverProjectDetailSectionFooterView new];
        if ([track_type isEqualToString:@"project_product"]) {
            footerView.title = @"查看更多竞品";
        }else {
            footerView.title = @"查看更多动态";
        }
        CA_H_WeakSelf(self)
        footerView.pushBlock = ^{
            CA_H_StrongSelf(self)
            if ([track_type isEqualToString:@"project_dynamic"] ||//项目动态
                [track_type isEqualToString:@"product_dynamic"] ||//竟品动态
                [track_type isEqualToString:@"investor_dynamic"]) {//投资方动态
                CA_MProjectTraceDynamicVC *dynamicVC = [CA_MProjectTraceDynamicVC new];
                dynamicVC.navigationItem.title = self.viewModel.data_list[section][@"track_name"];
                dynamicVC.project_id = self.project_id;
                if ([track_type isEqualToString:@"project_dynamic"]) {
                    dynamicVC.urlStr = CA_M_Api_ListProjectDynamic;
                    dynamicVC.modelClass = @"CA_MDiscoverNews_list";
                }else if ([track_type isEqualToString:@"product_dynamic"]) {
                    dynamicVC.urlStr = CA_M_Api_ListProductDynamic;
                    dynamicVC.modelClass = @"CA_MDiscoverNews_list";
                }else if ([track_type isEqualToString:@"investor_dynamic"]) {
                    dynamicVC.urlStr = CA_M_Api_ListInvestorDynamic;
                    dynamicVC.modelClass = @"CA_MProjectTraceInvestedModel";
                }
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [[self currentViewController].navigationController pushViewController:dynamicVC animated:YES];
                });
            }else if ([track_type isEqualToString:@"project_product"]){//相关竟品
                CA_MProjectTraceMutilTagsVC *mutilTagsVC = [CA_MProjectTraceMutilTagsVC new];
                mutilTagsVC.navigationItem.title = self.viewModel.data_list[section][@"track_name"];
                mutilTagsVC.project_id = self.project_id;
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [[self currentViewController].navigationController pushViewController:mutilTagsVC animated:YES];
                });
            }
        };
        return footerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger total_count = [self.viewModel.data_list[section][@"total_count"] integerValue];
    return total_count > 3?26*2*CA_H_RATIO_WIDTH:CGFLOAT_MIN;
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

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        CA_H_WeakSelf(self)
        _emptyView = [CA_MEmptyView newTitle:@"暂未关联项目" messageStr:@"关联外部数据库项目后，系统将可实时追踪 并汇集项目最新动态" buttonTitle:@"添加项目关联" top:60*CA_H_RATIO_WIDTH onButton:^{
            CA_H_StrongSelf(self)
            
            UIViewController *vc = [self currentViewController];
            if (vc) {
                CA_MNewSearchProjectVC *searchProjectVC = [CA_MNewSearchProjectVC new];
                searchProjectVC.project_id = self.project_id;
                searchProjectVC.finishedBlock = ^{
                    CA_H_StrongSelf(self)

                    self.relation = YES;
                    
                    self.viewModel.loadDataBlock(self.project_id);
                };
                
                CA_MNavigationController *nav = [[CA_MNavigationController alloc] initWithRootViewController:searchProjectVC];
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [vc presentViewController:nav animated:YES completion:nil];
                });
            }
            
        } imageName:@"empty_project"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

-(CA_MProjectTraceViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MProjectTraceViewModel new];
        _viewModel.loadingView = self;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            
            self.emptyView.hidden = [NSObject isValueableObject:self.viewModel.data_list];
            
            if (self.isRelation) {
                
                self.relation = NO;
                
                NSDictionary *newDic = @{@"track_list":@[@"关联项目"],
                                         @"track_name":@"关联项目",
                                         @"track_type":@"relevance_project",
                                         @"total_count":@"0"
                                         };
                
                [self.viewModel.data_list insertObject:newDic atIndex:0];
            }
            
            [self.mj_header endRefreshing];
            
            CA_H_DISPATCH_MAIN_THREAD(^{
                [self reloadData];
            });
        };
    }
    return _viewModel;
}

@end
