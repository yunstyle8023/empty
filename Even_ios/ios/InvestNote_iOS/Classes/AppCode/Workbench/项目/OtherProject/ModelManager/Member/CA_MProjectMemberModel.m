//
//  CA_MProjectMemberModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectMemberModel.h"

@implementation CA_MMemberModel

@end

@implementation CA_MProjectMemberModel

-(void)setMember_list:(NSMutableArray<CA_MMemberModel *> *)member_list{
    if (![member_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in member_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MMemberModel modelWithDictionary:dic]];
        }
    }
    _member_list = temp;
}
-(void)setManager_list:(NSMutableArray<CA_MMemberModel *> *)manager_list{
    if (![manager_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in manager_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MMemberModel modelWithDictionary:dic]];
        }
    }
    _manager_list = temp;
}
@end
