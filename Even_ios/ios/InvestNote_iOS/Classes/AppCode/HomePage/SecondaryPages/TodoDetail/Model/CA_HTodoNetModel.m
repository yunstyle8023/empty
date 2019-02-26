//
//  CA_HTodoNetModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HTodoNetModel.h"

@implementation CA_HTodoNetModel

// 待办参数
+ (void)listTaskParams:(void(^)(CA_HNetModel * netModel))callBack {
    [CA_HNetManager postUrlStr:CA_H_Api_ListTaskParams parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

// 修改待办
+ (void)updateTodo:(NSNumber *)todoId
             model:(CA_HTodoModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(todoId&&model)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *objectType = model.object_id.integerValue?@"project":@"person";
    NSDictionary *parameters = @{@"todo_id": todoId,
                                 @"object_type": objectType,
                                 @"object_id": model.object_id.integerValue==0?@"pass":model.object_id,
                                 @"todo_name": model.todo_name,
                                 @"member_id_list": model.member_id_list?:@[],
                                 @"ts_finish":model.ts_finish?:@(0),
                                 @"todo_content":model.todo_content?:@"",
                                 @"file_id_list":model.file_id_list?:@[],
                                 @"tag_level": model.tag_level?:@(1),
                                 @"remind_time":model.remind_time?:[NSNull null],
                                 };
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_UpdateTodo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 删除待办

+ (void)deleteTodo:(CA_HTodoDetailModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!model) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *objectType = model.object_id.integerValue?@"project":@"person";
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": model.object_id.integerValue?model.object_id:@"pass",
                                 @"todo_id": model.todo_id
                                 };
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteTodo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 添加待办

+ (void)createTodo:(CA_HTodoModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!model) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *objectType = model.object_id.integerValue?@"project":@"person";
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": model.object_id.integerValue==0?@"pass":model.object_id,
                                 @"todo_name": model.todo_name,
                                 @"member_id_list": model.member_id_list?:@[],
                                 @"ts_finish":model.ts_finish?:@(0),
                                 @"todo_content":model.todo_content?:@"",
                                 @"file_id_list":model.file_id_list?:@[],
                                 @"tag_level": model.tag_level?:@(1),
                                 @"remind_time":model.remind_time?:[NSNull null],
                                 };
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_CreateTodo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 待办评论
// 添加待办评论
+ (void)addTodoComment:(NSNumber *)todoId
              objectId:(NSNumber *)objectId
       conmmentContent:(NSString *)conmmentContent
      noticeUserIdList:(NSArray *)noticeUserIdList
              callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(todoId&&conmmentContent&&noticeUserIdList)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *objectType = objectId.integerValue?@"project":@"person";
    if (objectId.integerValue == 0) {
        objectId = (id)@"pass";
    }

    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": objectId,
                                 @"todo_id": todoId,
                                 @"comment_content": conmmentContent,
                                 @"notice_user_id_list": noticeUserIdList
                                 };
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_AddTodoComment parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

// 删除待办评论
+ (void)deleteTodoComment:(NSNumber *)todoId
                 objectId:(NSNumber *)objectId
               conmmentId:(NSNumber *)conmmentId
                 callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(todoId&&objectId&&conmmentId)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *objectType = objectId.integerValue?@"project":@"person";
    if (objectId.integerValue == 0) {
        objectId = (id)@"pass";
    }
    
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": objectId,
                                 @"todo_id": todoId,
                                 @"comment_id": conmmentId};
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteTodoComment parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 成员列表

+ (void)listMember:(NSNumber *)projectId
          callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!projectId) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{@"project_id": projectId,
                                 @"data_type": @"list"};
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_ListMember parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 待办详情

+ (void)queryTodo:(NSNumber *)todoId
         objectId:(NSNumber *)objectId
         callBack:(void(^)(CA_HNetModel * netModel))callBack view:(UIView *)view {
    if (!(todoId&&objectId)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    NSString *objectType = objectId.integerValue?@"project":@"person";
    
    if (objectId.integerValue == 0) {
        objectId = (id)@"pass";
    }
    
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": objectId,
                                 @"todo_id": todoId};
    
    if (view) {
        [CA_HProgressHUD loading:view];
    }
    [CA_HNetManager postUrlStr:CA_H_Api_QueryTodo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (view) {
            [CA_HProgressHUD hideHud:view];
        }
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

#pragma mark --- 待办状态
+ (void)updateTodoStatus:(NSNumber *)todoId
                objectId:(NSNumber *)objectId
                  status:(NSString *)status
                callBack:(void(^)(CA_HNetModel * netModel))callBack {
    
    if (!(todoId&&objectId&&status)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    NSString *objectType = objectId.integerValue?@"project":@"person";
    NSString *changeStatus = [status isEqualToString:@"finish"]?@"ready":@"finish";
    if (objectId.integerValue == 0) {
        objectId = (id)@"pass";
    }
    
    NSDictionary *parameters = @{@"object_type": objectType,
                                 @"object_id": objectId,
                                 @"todo_id": todoId,
                                 @"status": changeStatus};
    [CA_HProgressHUD showHud:nil];
    [CA_HNetManager postUrlStr:CA_H_Api_UpdateTodoStatus parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (callBack) {
            callBack(netModel);
        }
    } progress:nil];
}

@end
