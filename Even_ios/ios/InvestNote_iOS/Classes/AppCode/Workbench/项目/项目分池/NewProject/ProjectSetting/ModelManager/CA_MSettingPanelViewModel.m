//
//  CA_MSettingPanelViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingPanelViewModel.h"
#import "CA_MSettingPanelModel.h"

@implementation CA_MSettingPanelViewModel

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        [self requestData];
    }
    return _dataSource;
}

-(void)requestData{
    if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_Api_QueryProjectPanel parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data[@"data_list"]]) {
                    NSMutableArray *temp = @[].mutableCopy;
                    for (NSDictionary *dic in netModel.data[@"data_list"]) {
                        CA_MSettingPanelModel *model = [CA_MSettingPanelModel modelWithDictionary:dic];
                        [temp addObject:model];
                    }
                    [self.dataSource addObject:temp];
                }
                
                if (self.finishedBlock) self.finishedBlock();
            }
        }
    } progress:nil];
}

-(void)editPanelSettingWithData:(NSArray<CA_MSettingPanelModel *> *)data_list success:(void (^)(void))resultBlock{
    
    NSMutableArray *temp = @[].mutableCopy;
    
    for (int i = 0; i < data_list.count; i++) {
        
        CA_MSettingPanelModel *model = data_list[i];
        NSDictionary *dic = [model dictionaryFromModel];
        
        NSMutableDictionary *tempDic = @{}.mutableCopy;
        [tempDic setObject:dic[@"split_pool_id"] forKey:@"split_pool_id"];
        [tempDic setObject:dic[@"is_show"] forKey:@"is_show"];
        [tempDic setObject:@(i+1) forKey:@"sort_num"];
        
        [temp addObject:tempDic];
        
    }
    
    if (![NSObject isValueableObject:temp]) {
        return;
    }
    NSDictionary *parameters = @{@"split_pool_list":temp};
    
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateProjectPanel parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                resultBlock?resultBlock():nil;
                
                return ;
            }
        }
        
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

@end
