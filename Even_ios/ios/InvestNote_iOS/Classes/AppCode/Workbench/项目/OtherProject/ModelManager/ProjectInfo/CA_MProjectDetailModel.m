//
//  CA_MProjectDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectDetailModel.h"

@implementation CA_MInvest_history
//-(void)setTs_invest:(NSString *)ts_invest{
//    _ts_invest = ts_invest;
//    if (ts_invest) {
//        NSDate *date = [NSDate dateWithString:ts_invest format:@"y-M-d'T'H:m:s.z'Z'"];
//        _ts_invest = [NSString stringWithFormat:@"%ld.%ld.%ld",(long)date.year,(long)date.month,(long)date.day];
//    }
//}
@end

@implementation CA_MHeader_info
@end

@implementation CA_MProcedure_status
@end

@implementation CA_MValuation
@end

@implementation CA_MSource
@end

@implementation CA_MValuation_method
@end

@implementation CA_MBasic_info
@end

@implementation CA_MCompany_info
//-(void)setFound_time:(NSString *)found_time{
//    _found_time = found_time;
//    if (found_time) {
//        NSDate *date = [NSDate dateWithString:found_time format:@"y-M-d'T'H:m:s.z'Z'"];
//        _found_time = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)date.year,(long)date.month,(long)date.day];
//    }
//}
@end

@implementation CA_MTag_list
@end

@implementation CA_MProject_info
-(void)setTag_list:(NSArray<CA_MTag_list *> *)tag_list{
    if (![tag_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in tag_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MTag_list modelWithDictionary:dic]];
        }
    }
    _tag_list = temp;
}
@end

@implementation CA_MProject_person
@end

@implementation CA_MProjectDetailModel

-(void)setProject_person:(NSArray<CA_MProject_person *> *)project_person{
    if (![project_person isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in project_person) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MProject_person modelWithDictionary:dic]];
        }
    }
    _project_person = temp;
}

-(void)setInvest_history:(NSArray<CA_MInvest_history *> *)invest_history{
    if (![invest_history isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in invest_history) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MInvest_history modelWithDictionary:dic]];
        }
    }
    _invest_history = temp;
}

@end

