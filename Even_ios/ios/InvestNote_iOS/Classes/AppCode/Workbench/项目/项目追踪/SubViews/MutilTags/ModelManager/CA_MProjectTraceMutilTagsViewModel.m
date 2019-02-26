//
//  CA_MProjectTraceMutilTagsViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceMutilTagsViewModel.h"
#import "CA_MProjectTraceMutilTModel.h"
#import "CA_MProjectTraceMutilTagsView.h"
#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MProjectTraceMutilTagsViewModel

-(instancetype)init{
    if (self = [super init]) {
        self.homePage = NO;
    }
    return self;
}

-(CA_MProjectTraceMutiltRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MProjectTraceMutiltRequestModel new];
        _requestModel.project_id = self.project_id;
        _requestModel.tag_name = @"";
        _requestModel.page_num = @1;
        _requestModel.page_size = @20;
    }
    return _requestModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
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

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.finished = NO;
        self.firstRequest = YES;
        self.requestModel.page_num = @1;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.finished = NO;
        self.firstRequest = NO;
        self.requestModel.page_num = @1;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = YES;
        self.finished = NO;
        self.firstRequest = NO;
        self.requestModel.page_num = @(self.requestModel.page_num.intValue+1);
        [self requestData];
    };
}

-(void)requestData{
    if (self.isFirstRequest) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_M_Api_ListProjectProduct parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.loadingView];
        self.finished = YES;
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    if (self.isHomePage) {
                        if ([NSObject isValueableObject:netModel.data[@"tag_list"]]) {
                            
                            NSArray *tag_list = netModel.data[@"tag_list"];
                            [tag_list enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [self.tagNames addObject:obj];
                                CA_MProjectTraceMutilTagsView *tagView = [CA_MProjectTraceMutilTagsView new];
                                if (idx == 0) {
                                    [tagView configView:self.project_id
                                                tagName:obj
                                          traceCellType:TraceType_Tag];
                                }
                                [self.tagViews addObject:tagView];
                            }];
                        }
                    }
                    
                    if (!self.isLoadMore) {
                        [self.dataSource removeAllObjects];
                    }
                    
                    if ([NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        for (NSDictionary *dic in netModel.data[@"data_list"]) {
                            [self.dataSource addObject:[CA_MDiscoverCompatible_project_list modelWithDictionary:dic]];
                        }
                    }
                    
                    BOOL isHasData = (self.requestModel.page_num.intValue < [netModel.data[@"total_page"] intValue]);
                    self.finishedBlock?self.finishedBlock(isHasData):nil;
                    
                    return ;
                }
            }
        }
        self.finishedBlock?self.finishedBlock(NO):nil;
    } progress:nil];
}

@end
