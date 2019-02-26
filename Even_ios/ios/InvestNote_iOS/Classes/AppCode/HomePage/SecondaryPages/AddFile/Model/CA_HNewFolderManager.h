//
//  CA_HNewFolderManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HNewFolderManager : NSObject

+ (void)newFolder:(NSNumber *)parentId
       parentPath:(NSArray *)parentPath
         callBack:(void(^)(CA_HNetModel * netModel))callBack
       controller:(UIViewController *)controller;

+ (void)deleteFolder:(NSNumber *)parentId
              fileId:(NSNumber *)fileId
            filePath:(NSArray *)filePath
            callBack:(void(^)(CA_HNetModel * netModel))callBack
          controller:(UIViewController *)controller;

+ (void)renameFolder:(NSNumber *)parentId
          parentPath:(NSArray *)parentPath
              fileId:(NSNumber *)fileId
          folderName:(NSString *)folderName
            callBack:(void(^)(CA_HNetModel * netModel))callBack
          controller:(UIViewController *)controller;

@end
