//
//  CA_MCategoryModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCategoryModel.h"

@implementation CA_MCategory

@end

@implementation CA_MCategoryModel

-(void)setChildren:(NSArray<CA_MCategory *> *)children{
    if (![children isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in children) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MCategory modelWithDictionary:dic]];
        }
    }
    _children = temp;
}

@end
