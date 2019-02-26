//
//  CA_MCityModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCityModel.h"

@implementation CA_MCity

@end

@implementation CA_MCityModel

-(void)setChildren:(NSArray<CA_MCity *> *)children{
    if (![children isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in children) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MCity modelWithDictionary:dic]];
        }
    }
    _children = temp;
}

@end
