
//
//  CA_MPersonDetailModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailModel.h"

@implementation CA_MJob_experience

@end

@implementation CA_MContact_project

@end

@implementation CA_MHuman_detail

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

@implementation CA_MPersonDetailModel

-(void)setContact_project:(NSArray<CA_MContact_project *> *)contact_project{
    if (![contact_project isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in contact_project) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MContact_project modelWithDictionary:dic]];
        }
    }
    _contact_project = temp;
}

-(void)setJob_experience:(NSArray<CA_MJob_experience *> *)job_experience{
    if (![job_experience isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in job_experience) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [temp addObject:[CA_MJob_experience modelWithDictionary:dic]];
        }
    }
    _job_experience = temp;
}

@end
