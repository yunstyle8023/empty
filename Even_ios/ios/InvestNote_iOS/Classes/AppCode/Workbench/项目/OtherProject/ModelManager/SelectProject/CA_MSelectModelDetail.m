//
//  CA_MSelectModelDetail.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSelectModelDetail.h"

@implementation CA_MSelectModelDetail

-(void)setInvest_history_list:(NSArray<CA_MInvest_history *> *)invest_history_list{
    if (![invest_history_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in invest_history_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MInvest_history modelWithDictionary:dic]];
        }
    }
    _invest_history_list = temp;
}

@end
