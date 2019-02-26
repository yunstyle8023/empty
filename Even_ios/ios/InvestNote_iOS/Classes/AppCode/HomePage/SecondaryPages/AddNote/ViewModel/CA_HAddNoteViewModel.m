//
//  CA_HAddNoteViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteViewModel.h"

#import "CA_HLocationManager.h"

@interface CA_HAddNoteViewModel ()

@property (nonatomic, strong) id locationManager;

@end

@implementation CA_HAddNoteViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        _parameters = mutDic;
    }
    return _parameters;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)saveNote {
    CA_H_WeakSelf(self);
    self.locationManager = [CA_HLocationManager singleLocation:^(NSArray *location) {
        CA_H_StrongSelf(self);
        [self.parameters setObject:location forKey:@"location"];
        [self createNote];
    }];
}

- (void)createNote {
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:self.urlStr parameters:self.parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    CA_H_StrongSelf(self);
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshNoteListNotification object:self.parameters[@"object_type"]];
                    // 跳转详情
                    if (self.pushToDetailBlock) {
                        self.pushToDetailBlock(netModel.data);
                    }
                    return ;
                }
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } progress:nil];
}

- (void)setContent:(NSArray<CA_HNoteContentModel *> *)content {
    NSMutableArray *array = [NSMutableArray new];
    for (CA_HNoteContentModel *model in content) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:model.type?:@"" forKey:@"type"];
        [dic setObject:model.content?:@"" forKey:@"content"];
        [dic setObject:model.img_width?:@(0) forKey:@"img_width"];
        [dic setObject:model.img_height?:@(0) forKey:@"img_height"];
        [dic setObject:model.file_id?:@(0) forKey:@"file_id"];
        [dic setObject:model.file_name?:@"" forKey:@"file_name"];
        [dic setObject:model.file_type?:@"" forKey:@"file_type"];
        [dic setObject:model.file_size?:@(0) forKey:@"file_size"];
        [dic setObject:model.file_url?:@"" forKey:@"file_url"];
        [dic setObject:model.file_preview_url?:@"" forKey:@"file_preview_url"];
        [dic setObject:model.record_duration?:@(0) forKey:@"record_duration"];
        
        [array addObject:dic];
    }
    [self.parameters setObject:array forKey:@"content"];
}

#pragma mark --- Delegate

@end
