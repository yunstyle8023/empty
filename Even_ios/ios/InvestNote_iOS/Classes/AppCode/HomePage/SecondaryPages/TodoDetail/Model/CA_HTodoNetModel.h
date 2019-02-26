//
//  CA_HTodoNetModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HTodoModel.h"
#import "CA_HTodoDetailModel.h"

@interface CA_HTodoNetModel : NSObject

// 待办参数
+ (void)listTaskParams:(void(^)(CA_HNetModel * netModel))callBack;

// 待办状态
+ (void)updateTodoStatus:(NSNumber *)todoId
                objectId:(NSNumber *)objectId
                  status:(NSString *)status
                callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 待办详情
+ (void)queryTodo:(NSNumber *)todoId
         objectId:(NSNumber *)objectId
         callBack:(void(^)(CA_HNetModel * netModel))callBack
             view:(UIView *)view;

// 成员列表
+ (void)listMember:(NSNumber *)projectId
          callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 添加待办评论
+ (void)addTodoComment:(NSNumber *)todoId
              objectId:(NSNumber *)objectId
       conmmentContent:(NSString *)conmmentContent
      noticeUserIdList:(NSArray *)noticeUserIdList
              callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 删除待办评论
+ (void)deleteTodoComment:(NSNumber *)todoId
                 objectId:(NSNumber *)objectId
               conmmentId:(NSNumber *)conmmentId
                 callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 添加待办
+ (void)createTodo:(CA_HTodoModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 删除待办
+ (void)deleteTodo:(CA_HTodoDetailModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 修改待办
+ (void)updateTodo:(NSNumber *)todoId
             model:(CA_HTodoModel *)model
          callBack:(void(^)(CA_HNetModel * netModel))callBack;

@end
