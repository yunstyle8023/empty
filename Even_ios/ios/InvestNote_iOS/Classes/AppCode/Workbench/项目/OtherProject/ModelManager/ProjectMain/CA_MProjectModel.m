
//
//  CA_MProjectModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectModel.h"

@implementation CA_MProjectRisk_Tag_ListModel

@end

@implementation CA_MProjectTotal_AmountModel 

@end

@implementation CA_MProjectNetModel

@end

@implementation CA_MProjectCategoryModel

@end

@implementation CA_MProjectModel

-(void)setRisk_tag_list:(NSArray<CA_MProjectRisk_Tag_ListModel *> *)risk_tag_list{
    if (![risk_tag_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in risk_tag_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProjectRisk_Tag_ListModel modelWithDictionary:dic]];
        }
    }
    _risk_tag_list = temp;
}

@end

