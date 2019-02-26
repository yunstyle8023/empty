//
//  CA_HNoteNetManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteNetManager.h"

@implementation CA_HNoteNetManager

#pragma mark --- 笔记评论
// 添加笔记评论
+ (void)addNoteComment:(NSNumber *)noteId
            objectType:(NSString *)objectType
              objectId:(NSNumber *)objectId
       conmmentContent:(NSString *)conmmentContent
      noticeUserIdList:(NSArray *)noticeUserIdList
              callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(noteId&&objectType&&conmmentContent&&noticeUserIdList)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": objectId?:@(0),
                                 @"note_id": noteId,
                                 @"comment_content": conmmentContent,
                                 @"notice_user_id_list": noticeUserIdList
                                 };
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_AddNoteComment parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

// 删除笔记评论
+ (void)deleteNoteComment:(NSNumber *)conmmentId
                 callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!conmmentId) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{@"comment_id": conmmentId};
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteNoteComment parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 机构成员列表

+ (void)listCompanyUser:(void(^)(CA_HNetModel * netModel))callBack {
    
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_ListCompanyUser parameters:nil callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 笔记详情

+ (void)queryNote:(NSNumber *)noteId
         callBack:(void(^)(CA_HNetModel * netModel))callBack view:(UIView *)view {
    if (!noteId) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }

    NSDictionary *parameters = @{@"note_id": noteId};
    
    if (view) {
        [CA_HProgressHUD loading:view];
    }
    [CA_HNetManager postUrlStr:CA_H_Api_QueryNote parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (view) {
            [CA_HProgressHUD hideHud:view];
        }
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

@end
