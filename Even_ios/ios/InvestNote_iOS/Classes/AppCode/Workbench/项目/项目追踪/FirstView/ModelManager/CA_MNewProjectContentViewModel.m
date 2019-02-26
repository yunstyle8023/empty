//
//  CA_MNewProjectContentViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectContentViewModel.h"
#import "CA_MProjectModel.h"
#import "CA_MProjectMemberModel.h"

@implementation CA_MNewProjectContentViewModel

-(dispatch_block_t)loadDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        [self requestData];
    };
}

-(void)requestData{
    [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_Api_QueryProjectHome parameters:@{@"project_id":self.pId} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.loadingView];
        
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue==0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    self.model = [CA_MProjectModel modelWithDictionary:netModel.data];
                }
            }else if (netModel.errcode.intValue==21009) {//项目不存在
                [CA_H_NotificationCenter postNotificationName:CA_M_RefreshProjectListNotification
                                                       object:nil];
            }
        }
        
        self.finished = YES;
        
        self.finishedBlock?self.finishedBlock():nil;
        
    } progress:nil];
}

-(dispatch_block_t)loadMemberDataBlock{
    CA_H_WeakSelf(self)
    return ^(){
        CA_H_StrongSelf(self)
        [self requestMemberData];
    };
}

-(void)requestMemberData{
    NSDictionary* parameters = @{@"project_id":self.pId,
                                 @"data_type":@"dict"
                                 };
    [CA_HNetManager postUrlStr:CA_M_Api_ListMember parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.memberModel = [CA_MProjectMemberModel modelWithDictionary:netModel.data];
                }
            }
        }
        self.memberBlock?self.memberBlock():nil;
    } progress:nil];
}

-(void)updateMemberRoleWithPid:(NSNumber *)pid
                       user_id:(NSNumber *)user_id
                member_type_id:(NSNumber *)member_type_id
                         block:(void (^)(void))block{
    NSDictionary* parameters = @{@"project_id":pid,
                                 @"user_id":user_id,
                                 @"member_type_id":member_type_id
                                 };
    
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateMemberRole parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                //修改成功之后记得更新一下 member_type_id
                //                self.model.member_type_id = member_type_id;
                //更新member_type_id 直接重新请求接口
                block?block():nil;
                //刷新项目列表
                [CA_H_NotificationCenter postNotificationName:CA_M_RefreshProjectListNotification object:nil];
                return ;
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

-(void)deleteMemberWithPid:(NSNumber *)pid
                   user_id:(NSNumber *)user_id
                     block:(void (^)(void))block{
    NSDictionary* parameters = @{@"project_id":pid,
                                 @"user_id":user_id
                                 };
    [CA_HNetManager postUrlStr:CA_M_Api_DeleteMember parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                block?block():nil;
                return ;
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

-(void)updateFollowProjectWithPid:(NSNumber *)pid
                        is_follow:(BOOL)is_follow
                            block:(void (^)(void))block{
    NSDictionary* parameters = @{@"project_id":pid,
                                 @"is_follow": @(is_follow)
                                 };
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateFollowProject parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                block?block():nil;
                return ;
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

-(void)updateProjectPrivacyWithPid:(NSNumber *)pid
                           privacy:(NSString *)privacy
                             block:(void (^)(NSString *result))block{
    NSDictionary* parameters = @{@"project_id":pid,
                                 @"privacy": privacy};
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateProjectPrivacy parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    block?block(netModel.data[@"privacy"]):nil;
                    return ;
                }
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

-(void)deleteOrQuitProjectWithPid:(NSNumber *)pid
                            isDel:(BOOL)isDel
                            block:(void (^)(void))block{
    [CA_HNetManager postUrlStr:isDel?CA_M_Api_DeleteProject:CA_M_Api_QuitProject parameters:@{@"project_id":pid} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                block?block():nil;
                return ;
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

@end























