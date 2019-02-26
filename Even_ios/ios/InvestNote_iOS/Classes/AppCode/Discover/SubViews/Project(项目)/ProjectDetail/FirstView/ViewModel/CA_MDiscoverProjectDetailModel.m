
//
//  CA_MDiscoverProjectDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MRequestModel

@end

@implementation CA_MDiscoverProjectDetailRequestModel

@end

@implementation CA_MDiscoverNews_list

@end

@implementation CA_MDiscoverNews_data

-(void)setNews_list:(NSArray<CA_MDiscoverNews_list *> *)news_list{
    if (![news_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in news_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverNews_list modelWithDictionary:dic]];
        }
    }
    _news_list = temp;
}

@end

@implementation CA_MDiscoverCompatible_project_list

@end

@implementation CA_MDiscoverCompatible_project_data

-(void)setCompatible_project_list:(NSArray<CA_MDiscoverCompatible_project_list *> *)compatible_project_list{
    if (![compatible_project_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in compatible_project_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverCompatible_project_list modelWithDictionary:dic]];
        }
    }
    _compatible_project_list = temp;
}

@end

@implementation CA_MDiscoverProduct_list

@end

@implementation CA_MDiscoverProduct_data

-(void)setProduct_list:(NSArray<CA_MDiscoverProduct_list *> *)product_list{
    if (![product_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in product_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverProduct_list modelWithDictionary:dic]];
        }
    }
    _product_list = temp;
}

@end

@implementation CA_MDiscoverMember_list

@end

@implementation CA_MDiscoverMember_data

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

@implementation CA_MDiscoverGp_list

@end

@implementation CA_MDiscoverInvestHistory_list 

-(void)setGp_list:(NSArray<CA_MDiscoverGp_list *> *)gp_list{
    if (![gp_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in gp_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverGp_list modelWithDictionary:dic]];
        }
    }
    _gp_list = temp;
}

@end

@implementation CA_MDiscoverProjectDetailModel

-(void)setInvest_history_list:(NSArray<CA_MDiscoverInvestHistory_list *> *)invest_history_list{
    if (![invest_history_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in invest_history_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MDiscoverInvestHistory_list modelWithDictionary:dic]];
        }
    }
    _invest_history_list = temp;
}

@end
