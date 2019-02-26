//
//  CA_MNewProjectModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectModel.h"

@implementation CA_MNewProjectSplitPoolListModel

-(void)setPool_list:(NSMutableArray<CA_MProjectModel *> *)pool_list{
    if (![pool_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in pool_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProjectModel modelWithDictionary:dic]];
        }
    }
    _pool_list = temp;
}

@end

@implementation CA_MNewProjectSplitPoolModel

@end

@implementation CA_MNewProjectModel

-(void)setSplit_pool_count:(NSMutableArray<CA_MNewProjectSplitPoolModel *> *)split_pool_count{
    if (![split_pool_count isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in split_pool_count) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MNewProjectSplitPoolModel modelWithDictionary:dic]];
        }
    }
    _split_pool_count = temp;
}

-(void)setSplit_pool_list:(NSMutableArray<CA_MNewProjectSplitPoolListModel *> *)split_pool_list{
    if (![split_pool_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in split_pool_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MNewProjectSplitPoolListModel modelWithDictionary:dic]];
        }
    }
    _split_pool_list = temp;
}

@end
