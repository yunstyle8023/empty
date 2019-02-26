//
//  CA_MProjectTraceViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceViewModel.h"
#import "CA_MDiscoverProjectDetailModel.h"

//CA_MDiscoverCompatible_project_list

//CA_MDiscoverNews_list

@interface CA_MProjectTraceViewModel ()

@end

@implementation CA_MProjectTraceViewModel

-(NSMutableArray *)data_list{
    if (!_data_list) {
        _data_list = @[].mutableCopy;
    }
    return _data_list;
}

- (void (^)(NSNumber *))loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(NSNumber *project_id){
        CA_H_StrongSelf(self)
        self.finished = NO;
        self.showLoading = YES;
        [self requestData:project_id];
    };
}

-(void (^)(NSNumber *))refreshBlock{
    CA_H_WeakSelf(self)
    return ^(NSNumber *project_id){
        CA_H_StrongSelf(self)
        self.finished = NO;
        self.showLoading = NO;
        [self requestData:project_id];
    };
}

-(void)requestData:(NSNumber *)project_id{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:project_id,@"project_id", nil];
    
    if (self.isShowLoading) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_M_Api_ListTrackHome parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        self.finished = YES;
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([NSObject isValueableObject:netModel.data]) {
                    if ([NSObject isValueableObject:netModel.data[@"data_list"]]) {
                        [self.data_list removeAllObjects];
                        NSArray *data_list = netModel.data[@"data_list"];
                        [self.data_list addObjectsFromArray:data_list];
                        self.finishedBlock?self.finishedBlock():nil;
                        return ;
                    }
                }
            }
        }
        self.finishedBlock?self.finishedBlock():nil;
//        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

@end
