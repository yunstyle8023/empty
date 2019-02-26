//
//  CA_MDiscoverInvestmentManageFoundsModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentManageFoundsModel.h"

@implementation CA_MDiscoverInvestmentBusiness_TraceModel

@end

@implementation CA_MDiscoverInvestmentPublic_Investment_EventdModel

@end

@implementation CA_MDiscoverInvestmentManaged_FundModel

@end

@implementation CA_MDiscoverInvestmentInvestor_ListModel

@end

@implementation CA_MDiscoverInvestmentInvestment_FundModel

-(void)setInvestor_list:(NSMutableArray<CA_MDiscoverInvestmentInvestor_ListModel *> *)investor_list{
    if (![investor_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in investor_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverInvestmentInvestor_ListModel modelWithDictionary:dic]];
        }
    }
    _investor_list = temp;
}


@end

@implementation CA_MDiscoverInvestmentRequestModel

@end

@implementation CA_MDiscoverInvestmentManageFoundsModel

-(void)setData_list:(NSMutableArray<CA_MDiscoverMember_list *> *)data_list{
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverMember_list modelWithDictionary:dic]];
        }
    }
    _data_list = temp;
}

@end
