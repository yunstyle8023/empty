
//
//  CA_MNewPersonViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewPersonViewModel.h"
#import "CA_MPersonModel.h"

@interface CA_MNewPersonViewModel ()
@property (nonatomic,assign,getter=isFirstLoad) BOOL firstLoad;
@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end

@implementation CA_MNewPersonViewModel

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        self.loadDataBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.firstLoad = YES;
        [self requestData];
    };
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = NO;
        self.firstLoad = NO;
        [self requestData];
    };
}

-(dispatch_block_t)loadMoreBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.loadMore = YES;
        self.firstLoad = NO;
        [self requestData];
    };
}

-(void)requestData{
    if (self.loadingView && self.isFirstLoad) [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_Api_ListHumanrResource parameters:@{@"tag_id_list":self.tagList,@"keyword":@""} callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    if (!self.isLoadMore) [self.dataSource removeAllObjects];
                    
                    for (NSDictionary* dic in netModel.data) {
                        CA_MPersonModel* model = [CA_MPersonModel modelWithDictionary:dic];
                        model.select = YES;
                        [self.dataSource addObject:model];
                    }
                    
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
        
        if (self.finishedBlock) self.finishedBlock();
    } progress:nil];
}

-(void)deletePersonWithId:(NSNumber *)human_id success:(dispatch_block_t)deleteBlock{
    NSDictionary* parameters = @{@"human_id":human_id};
    [CA_HNetManager postUrlStr:CA_M_Api_DeleteHumanResource parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                
                [self.dataSource enumerateObjectsUsingBlock:^(CA_MPersonModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.human_id == human_id) {
                        [self.dataSource removeObject:obj];
                        *stop = YES;
                    }
                }];
                
                deleteBlock();
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
    } progress:nil];
}

-(NSMutableArray *)tagList{
    if (!_tagList) {
        _tagList = @[].mutableCopy;
    }
    return _tagList;
}

@end
