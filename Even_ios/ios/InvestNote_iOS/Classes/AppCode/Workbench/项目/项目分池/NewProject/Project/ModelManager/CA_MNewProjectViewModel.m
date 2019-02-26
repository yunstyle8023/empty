//
//  CA_MNewProjectViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectViewModel.h"
#import "CA_MNewProjectModel.h"

@interface CA_MNewProjectViewModel ()

@end

@implementation CA_MNewProjectViewModel

-(CA_MNewProjectModel *)model{
    if (!_model) {
        _model = [CA_MNewProjectModel new];
        self.refresh = NO;
        [self requestData];
    }
    return _model;
}

-(dispatch_block_t)refreshBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        self.refresh = YES;
        [self requestData];
    };
}

-(void)requestData{
    if (!self.isRefresh) {
        if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    }
    [CA_HNetManager postUrlStr:CA_M_Api_ListProjectHome parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                self.model = [CA_MNewProjectModel modelWithDictionary:netModel.data];
            }
        }
        
        self.finished = YES;
        
        if (self.finishedBlock) self.finishedBlock();
        
    } progress:nil];
}

@end
