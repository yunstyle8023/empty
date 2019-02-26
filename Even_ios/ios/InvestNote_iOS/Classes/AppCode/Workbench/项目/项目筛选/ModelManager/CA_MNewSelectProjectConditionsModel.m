//
//  CA_MNewSelectProjectConditionsModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectConditionsModel.h"

@implementation CA_MNewSelectProjectConditionsDataListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"ids" :@"id",
                        @"name" : @"name"};
    return dic;
}


@end

@implementation CA_MNewSelectProjectConditionsModel

-(void)setData_list:(NSMutableArray<CA_MNewSelectProjectConditionsDataListModel *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MNewSelectProjectConditionsDataListModel modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
