//
//  CA_MDiscoverProjectDetailTagViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailTagViewModel.h"
#import "CA_MDiscoverModel.h"
#import "CA_MDiscoverProjectDetailTagModel.h"

@interface CA_MDiscoverProjectDetailTagViewModel ()
@property (nonatomic,strong) CA_MDiscoverRequestModel *requestModel;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;

@end

@implementation CA_MDiscoverProjectDetailTagViewModel

-(CA_MDiscoverRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverRequestModel new];
        _requestModel.data_type = @"project";
        _requestModel.search_str = self.tagName;
        _requestModel.search_type = @"tag";
        _requestModel.page_size = @10;
        _requestModel.page_num = @1;
    }
    return _requestModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        [CA_HProgressHUD loading:self.loadingView];
        self.loadDataBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return  ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @1;
        [self.dataSource removeAllObjects];
        self.loadMore = NO;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^{
        CA_H_StrongSelf(self)
        self.requestModel.page_num = @(self.requestModel.page_num.intValue + 1);
        self.loadMore = YES;
        [self requestData];
    };
}

-(void)requestData{
    __block BOOL isAdd = YES;
    [CA_HNetManager postUrlStr:CA_M_SearchDataList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) {
            [CA_HProgressHUD hideHud:self.loadingView];
        }
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                self.total_count = netModel.data[@"total_count"];
                
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]]
                        &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        for (NSDictionary *dic in netModel.data[@"data_list"]) {
                            [self.dataSource addObject:[CA_MDiscoverProjectDetailTagModel modelWithDictionary:dic]];
                        }
                        //
                        isAdd = NO;
                    }
                }
            }
        }
        if (isAdd && self.isLoadMore) {//请求失败页数减1
            self.requestModel.page_num = @(self.requestModel.page_num.intValue - 1);
        }
        
        
        if (self.finishedBlock) {
            BOOL isHasData = (self.requestModel.page_num.intValue == [netModel.data[@"total_page"] intValue]);
            self.finishedBlock(self.isLoadMore, isHasData);
        }
    } progress:nil];
}

@end
