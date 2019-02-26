//
//  CA_HBusinessInformationModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationModel.h"

@implementation CA_HBusinessInformationContentModel

@end

@implementation CA_HBusinessInformationModel

- (NSArray *)arrayWith:(NSArray *)dataArray {
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in dataArray) {
        if ([dic isKindOfClass:[CA_HBusinessInformationContentModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HBusinessInformationContentModel modelWithDictionary:dic]];
        }
    }
    return array;
}

- (void)setBasic_info_list:(NSArray<CA_HBusinessInformationContentModel *> *)basic_info_list {
    NSArray *array = [self arrayWith:basic_info_list];
    if (array) {
        _basic_info_list = array;
    }
}

- (void)setPartners_list:(NSArray<CA_HBusinessInformationContentModel *> *)partners_list {
    NSArray *array = [self arrayWith:partners_list];
    if (array) {
        _partners_list = array;
    }
}

- (void)setMain_member_list:(NSArray<CA_HBusinessInformationContentModel *> *)main_member_list {
    NSArray *array = [self arrayWith:main_member_list];
    if (array) {
        _main_member_list = array;
    }
}

- (void)setChange_list:(NSArray<CA_HBusinessInformationContentModel *> *)change_list {
    if (![change_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in change_list) {
        if ([dic isKindOfClass:[CA_HBusinessInformationContentModel class]]) {
            [array addObject:dic];
        }else{
            CA_HBusinessInformationContentModel *model = [CA_HBusinessInformationContentModel modelWithDictionary:dic];
            [array addObject:model];
            model.countStr = @(array.count).stringValue;
        }
    }
    _change_list = array;
}

- (void)setBranch_list:(NSArray<CA_HBusinessInformationContentModel *> *)branch_list {
    NSArray *array = [self arrayWith:branch_list];
    if (array) {
        _branch_list = array;
    }
}

@end
