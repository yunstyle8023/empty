//
//  CA_MNewSearchProjectViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSearchProjectViewModel.h"
#import "CA_MSelectProjectNetModel.h"
#import "CA_MSelectModel.h"

@implementation CA_MNewSearchProjectViewModel

- (NSString *)title{
    return @"添加项目";
}

-(CA_MSelectProjectNetModel *)netModel{
    if (!_netModel) {
        _netModel = [CA_MSelectProjectNetModel new];
        _netModel.data_type = @"project";
        _netModel.search_type = @"keyword";
        _netModel.page_num = @1;
        _netModel.page_size = @10;
        _netModel.search_str = @"";
    }
    return _netModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        self.refreshBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.netModel.page_num = @(1);
        self.finished = NO;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = YES;
        self.netModel.page_num = @(self.netModel.page_num.intValue+1);
        self.finished = NO;
        [self requestData];
    };
}

-(void)requestData{
    
    [CA_HNetManager postUrlStr:CA_M_Api_SearchDataList parameters:[self.netModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        
        self.finished = YES;
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]] &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]){
                        if (!self.isLoadMore) {
                            [self.dataSource removeAllObjects];
                        }
                        for (NSDictionary* dic in netModel.data[@"data_list"]) {
                            CA_MSelectModel* model = [CA_MSelectModel modelWithDictionary:dic];
                            [self.dataSource addObject:model];
                        }
                        
                        BOOL isHasData = self.netModel.page_num.intValue < [netModel.data[@"page_count"] intValue];
                        self.finishedBlock?self.finishedBlock(isHasData):nil;
                        
                        return ;
                    }else {
                        [self.dataSource removeAllObjects];
                    }
                }
 
            }
            
        }
        //上拉加载更多请求失败时候 页数减1
        if (self.isLoadMore) {
            self.netModel.page_num = @(self.netModel.page_num.intValue-1);
        }
        
        self.finishedBlock?self.finishedBlock(NO):nil;
        
//        [CA_HProgressHUD showHudStr:netModel.errmsg];

    } progress:nil];
}

-(void (^)(NSNumber *, NSString *, dispatch_block_t))relevanceBlock{
    CA_H_WeakSelf(self)
    return ^(NSNumber *project_id,NSString *data_id,dispatch_block_t block){
        CA_H_StrongSelf(self)
        NSDictionary *parameters = @{@"project_id":project_id,
                                     @"data_id":data_id
                                     };
        [CA_HNetManager postUrlStr:CA_M_Api_UpdateProjectRelation parameters:parameters callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    block?block():nil;
                }
            }
        } progress:nil];
    };
}

@end
















