//
//  CA_HNewFileManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HNewFileManager : NSObject

+ (void)newFile:(NSNumber *)parentId
     parentPath:(NSArray *)parentPath
       fileList:(NSArray *)fileList
       callBack:(void(^)(CA_HNetModel * netModel))callBack;

+ (void)deleteFile:(NSNumber *)parentId
            fileId:(NSNumber *)fileId
          callBack:(void(^)(CA_HNetModel * netModel))callBack
        controller:(UIViewController *)controller;

+ (void)renamefile:(NSNumber *)parentId
        parentPath:(NSArray *)parentPath
            fileId:(NSNumber *)fileId
          fileName:(NSString *)fileName
          callBack:(void(^)(CA_HNetModel * netModel))callBack
        controller:(UIViewController *)controller;

+ (void)moveFile:(NSNumber *)parentId
      parentPath:(NSArray *)parentPath
          fileId:(NSNumber *)fileId
        callBack:(void(^)(CA_HNetModel * netModel))callBack;

@end
