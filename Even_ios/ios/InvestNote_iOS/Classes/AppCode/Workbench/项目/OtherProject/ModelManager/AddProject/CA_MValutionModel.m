//
//  CA_MValutionModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MValutionModel.h"

@implementation CA_MValutionModel

-(void)setChildren:(NSArray<CA_MValutionModel *> *)children{
    if (![children isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in children) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MValutionModel modelWithDictionary:dic]];
        }
    }
    _children = temp;
}

@end
