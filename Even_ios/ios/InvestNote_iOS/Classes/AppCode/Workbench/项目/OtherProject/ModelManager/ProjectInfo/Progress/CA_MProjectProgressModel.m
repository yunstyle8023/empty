//
//  CA_MProjectProgressModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressModel.h"

@implementation CA_MApproval_result

@end

@implementation CA_MApproval_user
@end

@implementation CA_MCreator
@end

@implementation CA_MProcedure_logModel
-(void)setApproval_user_list:(NSArray<CA_MApproval_user *> *)approval_user_list{
    if (![approval_user_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in approval_user_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MApproval_user modelWithDictionary:dic]];
        }
    }
    _approval_user_list = temp;
}
-(void)setApproval_result_list:(NSArray<CA_MApproval_result *> *)approval_result_list{
    if (![approval_result_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in approval_result_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MApproval_result modelWithDictionary:dic]];
        }
    }
    _approval_result_list = temp;
}
@end

@implementation CA_Mprocedure_viewModel

@end

@implementation CA_MProjectProgressModel

-(void)setProcedure_view:(NSArray<CA_Mprocedure_viewModel *> *)procedure_view{
    if (![procedure_view isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in procedure_view) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_Mprocedure_viewModel modelWithDictionary:dic]];
        }
    }
    _procedure_view = temp;
}
-(void)setProcedure_log:(NSArray<CA_MProcedure_logModel *> *)procedure_log{
    if (![procedure_log isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in procedure_log) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProcedure_logModel modelWithDictionary:dic]];
        }
    }
    _procedure_log = temp;
}
@end
