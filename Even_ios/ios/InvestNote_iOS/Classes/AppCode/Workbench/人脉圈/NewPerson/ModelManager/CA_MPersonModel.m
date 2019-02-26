//
//  CA_MPersonModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonModel.h"

@implementation CA_MPersonTagModel

@end

@implementation CA_MPersonModel

-(void)setTag_data:(NSArray<CA_MPersonTagModel *> *)tag_data{
    if (![tag_data isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in tag_data) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MPersonTagModel modelWithDictionary:dic]];
        }
    }
    _tag_data = temp;
}

@end
