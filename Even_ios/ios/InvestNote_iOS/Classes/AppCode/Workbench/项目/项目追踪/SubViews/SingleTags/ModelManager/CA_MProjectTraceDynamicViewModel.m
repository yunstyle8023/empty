//
//  CA_MProjectTraceDynamicViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceDynamicViewModel.h"
#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MProjectTraceDynamicViewModel

-(CA_MRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MRequestModel new];
        _requestModel.project_id = self.project_id;
        _requestModel.page_num = @1;
        _requestModel.page_size = @20;
    }
    return _requestModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        self.loadDataBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.firstLoad = YES;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return  ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @1;
        self.loadMore = NO;
        self.firstLoad = NO;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @(self.requestModel.page_num.intValue + 1);
        self.loadMore = YES;
        self.firstLoad = NO;
        [self requestData];
    };
}

-(void)requestData{
    
    if (self.isFirstLoad) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    
    [CA_HNetManager postUrlStr:self.urlStr parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView ) [CA_HProgressHUD hideHud:self.loadingView];

        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]]
                        &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        
                        if (!self.isLoadMore) {
                            [self.dataSource removeAllObjects];
                        }
                        
                        for (NSDictionary *dic in netModel.data[@"data_list"]) {
                            [self.dataSource addObject:[NSClassFromString(self.modelClass) modelWithDictionary:dic]];
                        }
                        
                        BOOL isHasData = (self.requestModel.page_num.intValue < [netModel.data[@"total_page"] intValue]);
                        self.finishedBlock?self.finishedBlock(self.isLoadMore, isHasData):nil;
                        
                        return ;
                    }
                }
            }
        }
        
        if (self.isLoadMore) {//请求失败页数减1
            self.requestModel.page_num = @(self.requestModel.page_num.intValue - 1);
        }
        
        self.finishedBlock?self.finishedBlock(self.isLoadMore, NO):nil;
    } progress:nil];
}

@end







