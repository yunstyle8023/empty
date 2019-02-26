//
//  CA_MNewProjectSingleViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectSingleViewModel.h"
#import "CA_MProjectModel.h"
#import "CA_MNewProjectListModel.h"
#import "CA_MNewProjectMultiView.h"

@interface CA_MNewProjectSingleViewModel ()
{
    NSURLSessionDataTask *_dataTask;
}

@property (nonatomic,assign,getter=isFirst) BOOL first;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@end

@implementation CA_MNewProjectSingleViewModel

-(NSString *)title{
    if (self.pool_id.intValue == 0) {//全部项目
        return @"全部项目";
    }else if (self.pool_id.intValue == 1) {//储备项目
        return @"储备项目";
    }else if (self.pool_id.intValue == 5) {//拟投项目
        return @"拟投项目";
    }else if (self.pool_id.intValue == 8) {//已投项目
        return @"已投项目";
    }else if (self.pool_id.intValue == 10) {//退出项目
        return @"退出项目";
    }else if (self.pool_id.intValue == 13) {//放弃项目
        return @"放弃项目";
    }else if (self.pool_id.intValue == 15) {//关注项目
        return @"关注项目";
    }
    return @"";
}

-(NSMutableArray *)tagNames{
    if (!_tagNames) {
        _tagNames = @[].mutableCopy;
    }
    return _tagNames;
}

-(NSMutableArray *)tagViews{
    if (!_tagViews) {
        _tagViews = @[].mutableCopy;
    }
    return _tagViews;
}

-(CA_MProjectNetModel *)netModel{
    if (!_netModel) {
        _netModel = [CA_MProjectNetModel new];
        _netModel.pool_id = @[self.pool_id];
        _netModel.tag_id = self.tag_id;
        _netModel.page_num = @1;
        _netModel.category_ids = @[].mutableCopy;
        _netModel.progress_status_ids = @[].mutableCopy;
        _netModel.invest_stage_ids = @[].mutableCopy;
        _netModel.user_ids = @[].mutableCopy;
    }
    return _netModel;
}

-(CA_MNewProjectListModel *)listModel{
    if (!_listModel) {
        if (_dataTask) return nil;
        self.first = YES;
        self.loadMore = NO;
        [self requestData];
    }
    return _listModel;
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.first = NO;
        self.loadMore = NO;
        self.finished = NO;
        self.netModel.page_num = @1;
        [self.listModel.data_list removeAllObjects];
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.first = NO;
        self.loadMore = YES;
        self.finished = NO;
        self.netModel.page_num = @(self.netModel.page_num.intValue+1);
        [self requestData];
    };
}

-(void)requestData{
    
    if (self.isFirst) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    
    if (self.isFiltrating) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    
    NSDictionary *parameters = @{
                                 @"category_ids":self.netModel.category_ids?self.netModel.category_ids:@[],
                                 @"progress_status_ids":self.netModel.progress_status_ids?self.netModel.progress_status_ids:@[],
                                 @"invest_stage_ids":self.netModel.invest_stage_ids?self.netModel.invest_stage_ids:@[],
                                 @"user_ids":self.netModel.user_ids?self.netModel.user_ids:@[],
                                 @"page_num":self.netModel.page_num,
                                 @"page_size":@(20),
                                 @"keyword":self.netModel.keyword?self.netModel.keyword:@"",
                                 @"pool_id":self.netModel.pool_id,
                                 @"tag_id":self.netModel.tag_id?self.netModel.tag_id:@0
                                 };

    _dataTask = [CA_HNetManager postUrlStr:CA_M_Api_ListProject parameters:parameters callBack:^(CA_HNetModel *netModel) {

        self.finished = YES;
        
        self.filtrating = NO;
        
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    if (!self.isLoadMore) {
                        self.listModel = [CA_MNewProjectListModel modelWithDictionary:netModel.data];
                    }else {
                        NSArray *moreDataArr = [CA_MNewProjectListModel modelWithDictionary:netModel.data].data_list;
                        [self.listModel.data_list addObjectsFromArray:moreDataArr];
                    }

                    if ([NSObject isValueableObject:self.listModel.project_tag_list]) {
                        for (CA_MProjectRisk_Tag_ListModel *model in self.listModel.project_tag_list) {
                            [self.tagNames addObject:model.tag_name];
                            CA_MNewProjectMultiView *multiView = [CA_MNewProjectMultiView new];
                            [multiView configViewWithPool_id:self.pool_id tag_id:model.tag_id];
                            [self.tagViews addObject:multiView];
                        }
                    }
                    
                    BOOL isHasMore = self.netModel.page_num.intValue < self.listModel.page_count.intValue;
                    
                    if (self.finishedBlock) self.finishedBlock(isHasMore);
                    
                    return;
                    
                }
            }
        }

        if (self.finishedBlock) self.finishedBlock(NO);
        
        if (self.isLoadMore) self.netModel.page_num = @(self.netModel.page_num.intValue-1);
        
//        [CA_HProgressHUD showHudStr:netModel.errmsg];
        
    } progress:nil];
}

@end
