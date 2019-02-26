
//
//  CA_MDiscoverSponsorDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailModel.h"

@implementation CA_MDiscoverSponsorContact_data

@end

@implementation CA_MDiscoverSponsorInclude_data

@end

@implementation CA_MDiscoverSponsorLp_moudle

@end

@implementation CA_MDiscoverSponsorMember_list

@end

@implementation CA_MDiscoverSponsorBase_info

@end

@implementation CA_MDiscoverSponsorDetailModel

-(void)setMember_list:(NSArray<CA_MDiscoverSponsorMember_list *> *)member_list{
    if (![member_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in member_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorMember_list modelWithDictionary:dic]];
        }
    }
    _member_list = temp;
}

-(void)setLp_moudle:(NSArray<CA_MDiscoverSponsorLp_moudle *> *)lp_moudle{
    if (![lp_moudle isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in lp_moudle) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverSponsorLp_moudle modelWithDictionary:dic]];
        }
    }
    _lp_moudle = temp;
}

@end
