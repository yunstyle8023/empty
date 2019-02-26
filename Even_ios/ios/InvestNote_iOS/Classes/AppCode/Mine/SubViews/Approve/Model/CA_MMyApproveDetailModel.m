//
//  CA_MMyApproveDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMyApproveDetailModel.h"

@implementation CA_MResult_detail

@end

@implementation CA_MApproval_member

@end

@implementation CA_MMyApproveDetailModel

-(void)setApproval_member:(NSArray<CA_MApproval_member *> *)approval_member{
    if (![approval_member isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in approval_member) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MApproval_member modelWithDictionary:dic]];
        }
    }
    _approval_member = temp;
}

-(void)setResult_detail:(NSArray<CA_MResult_detail *> *)result_detail{
    if (![result_detail isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in result_detail) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MResult_detail modelWithDictionary:dic]];
        }
    }
    _result_detail = temp;
}

@end
