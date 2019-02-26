//
//  CA_MNewSelectProjectViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectViewModel.h"
#import "CA_MNewSelectProjectConditionsModel.h"

@interface CA_MNewSelectProjectViewModel ()

@end

@implementation CA_MNewSelectProjectViewModel

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        [self requestData];
    }
    return _dataSource;
}

-(void)requestData{
    
    NSDictionary *parameters;
    
    if (self.pool_id) {
        parameters = @{@"pool_id":self.pool_id};
    }else {
        parameters = @{};
    }
    
    [CA_HNetManager postUrlStr:CA_M_Api_ListProjectConditions parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {

                    [netModel.data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CA_MNewSelectProjectConditionsModel *model = [CA_MNewSelectProjectConditionsModel modelWithDictionary:obj];
                        idx == 0 ? (model.selected = YES) : (model.selected = NO);
                        ((CA_MNewSelectProjectConditionsDataListModel *)[model.data_list firstObject]).selected = YES;
                        [self.dataSource addObject:model];
                    }];

                    if ([NSObject isValueableObject:self.dataSource]) {
                        CA_MNewSelectProjectConditionsModel *model = [self.dataSource firstObject];
                        self.field = model.field;
                    }
                }
            }
        }
        if (self.finished) {
            self.finished();
        }
    } progress:nil];
}

@end
