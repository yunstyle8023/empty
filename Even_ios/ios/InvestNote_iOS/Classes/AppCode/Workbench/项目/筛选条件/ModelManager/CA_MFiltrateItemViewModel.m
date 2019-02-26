//
//  CA_MFiltrateItemViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemViewModel.h"
#import "CA_HBaseModel.h"

@interface CA_MFiltrateItemViewModel ()

@end

@implementation CA_MFiltrateItemViewModel

-(instancetype)init{
    if (self = [super init]) {
        self.requestMethod = Request_Get;
        self.finished = NO;
    }
    return self;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        self.loadDataBlock();
    }
    return _dataSource;
}

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        if ([self.urlStr isEqualToString:CA_M_Api_ListProjectValutionmethod]) {
            [self requestDataWithPost];
        }else {
            [self requestDataWithGet];
        }
    };
}

-(void)requestDataWithPost{
//    [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:self.urlStr parameters:[NSObject isValueableObject:self.parameters]?self.parameters:@{} callBack:^(CA_HNetModel *netModel) {
//        [CA_HProgressHUD hideHud:self.loadingView];
        self.finished = YES;
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        [self.dataSource addObject:[NSClassFromString(self.className) modelWithDictionary:dic]];
                    }
                    
                    CA_HBaseModel *firstModel = [self.dataSource firstObject];
                    [firstModel setValue:@"1" forKey:@"selected"];
                    
                    [[firstModel valueForKey:@"children"][0] setValue:@"1" forKey:@"selected"];
                    
                    if ([NSObject isValueableObject:[[firstModel valueForKey:@"children"][0] valueForKey:@"children"]]) {
                        [[[firstModel valueForKey:@"children"][0] valueForKey:@"children"][0] setValue:@"1" forKey:@"selected"];
                    }
                    
                    self.finishedBlock?self.finishedBlock(self.dataSource):nil;
                    return ;
                }
            }
        }
        self.finishedBlock?self.finishedBlock(nil):nil;
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

-(void)requestDataWithGet{
//    [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager getUrlStr:self.urlStr parameters:[NSObject isValueableObject:self.parameters]?self.parameters:@{} callBack:^(CA_HNetModel *netModel) {
//        [CA_HProgressHUD hideHud:self.loadingView];
        self.finished = YES;
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        [self.dataSource addObject:[NSClassFromString(self.className) modelWithDictionary:dic]];
                    }
                    CA_HBaseModel *firstModel = [self.dataSource firstObject];
                    [firstModel setValue:@"1" forKey:@"selected"];
                    
                    [[firstModel valueForKey:@"children"][0] setValue:@"1" forKey:@"selected"];

                    if ([NSObject isValueableObject:[[firstModel valueForKey:@"children"][0] valueForKey:@"children"]]) {
                        [[[firstModel valueForKey:@"children"][0] valueForKey:@"children"][0] setValue:@"1" forKey:@"selected"];
                    }
                    
                    self.finishedBlock?self.finishedBlock(self.dataSource):nil;
                    return ;
                }
            }
        }
        self.finishedBlock?self.finishedBlock(nil):nil;
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

@end















