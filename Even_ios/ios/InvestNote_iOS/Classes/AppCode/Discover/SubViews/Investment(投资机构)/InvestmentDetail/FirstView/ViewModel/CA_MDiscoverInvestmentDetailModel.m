//
//  CA_MDiscoverInvestmentDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentDetailModel.h"

@implementation CA_MDiscoverInvestmentDetailMemberDict

-(void)setMember_list:(NSArray<CA_MDiscoverMember_list *> *)member_list{
    if (![member_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in member_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverMember_list modelWithDictionary:dic]];
        }
    }
    _member_list = temp;
}

@end

@implementation CA_MDiscoverInvestmentDetailBaseInfo

@end

@implementation CA_MDiscoverInvestmentDetailModel

-(void)setGp_moudle:(NSArray<CA_MDiscoverSponsorLp_moudle *> *)gp_moudle{
    if (![gp_moudle isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in gp_moudle) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorLp_moudle modelWithDictionary:dic]];
        }
    }
    _gp_moudle = temp;
}

@end
