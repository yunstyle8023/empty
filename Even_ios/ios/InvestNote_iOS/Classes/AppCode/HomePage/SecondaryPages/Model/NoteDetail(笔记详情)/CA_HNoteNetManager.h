//
//  CA_HNoteNetManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HNoteNetManager : NSObject

// 笔记详情
+ (void)queryNote:(NSNumber *)noteId
         callBack:(void(^)(CA_HNetModel * netModel))callBack
             view:(UIView *)view;

// 机构成员列表
+ (void)listCompanyUser:(void(^)(CA_HNetModel * netModel))callBack;

// 添加笔记评论
+ (void)addNoteComment:(NSNumber *)noteId
            objectType:(NSString *)objectType
              objectId:(NSNumber *)objectId
       conmmentContent:(NSString *)conmmentContent
      noticeUserIdList:(NSArray *)noticeUserIdList
              callBack:(void(^)(CA_HNetModel * netModel))callBack;

// 删除笔记评论
+ (void)deleteNoteComment:(NSNumber *)conmmentId
                 callBack:(void(^)(CA_HNetModel * netModel))callBack;

@end
