
//
//  CA_MNewProjectListModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectListModel.h"
#import "CA_MNewSelectProjectConditionsModel.h"
#import "CA_MProjectModel.h"

@implementation CA_MNewProjectListModel

-(void)setSplit_pool_list:(NSMutableArray<CA_MNewSelectProjectConditionsModel *> *)split_pool_list{
    if (![split_pool_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in split_pool_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MNewSelectProjectConditionsModel modelWithDictionary:dic]];
        }
    }
    _split_pool_list = temp;
}

-(void)setProject_tag_list:(NSMutableArray<CA_MProjectRisk_Tag_ListModel *> *)project_tag_list{
    if (![project_tag_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in project_tag_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProjectRisk_Tag_ListModel modelWithDictionary:dic]];
        }
    }
    _project_tag_list = temp;
}


-(void)setData_list:(NSMutableArray<CA_MProjectModel *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProjectModel modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
