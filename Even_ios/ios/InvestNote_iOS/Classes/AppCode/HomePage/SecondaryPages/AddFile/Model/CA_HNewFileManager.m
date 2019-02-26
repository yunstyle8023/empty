//
//  CA_HNewFileManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNewFileManager.h"

#import "NSString+CA_HStringCheck.h"

@implementation CA_HNewFileManager

#pragma mark --- 移动文件

+ (void)moveFile:(NSNumber *)parentId
      parentPath:(NSArray *)parentPath
          fileId:(NSNumber *)fileId
        callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(parentId&&parentPath&&fileId)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"file_id":fileId,
                                 @"parent_id":parentId,
                                 @"new_parent_path":parentPath
                                 };
    
    [CA_HNetManager postUrlStr:CA_H_Api_MoveFile parameters:parameters  callBack:callBack progress:nil];
}

#pragma mark --- 重命名文件

+ (void)renamefile:(NSNumber *)parentId
        parentPath:(NSArray *)parentPath
            fileId:(NSNumber *)fileId
          fileName:(NSString *)fileName
          callBack:(void(^)(CA_HNetModel * netModel))callBack
        controller:(UIViewController *)controller {
    
    [controller presentAlertTitle:CA_H_LAN(@"重命名")
                          message:nil
                          buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确定")]
                       clickBlock:^(UIAlertController *alert, NSInteger index) {
                           if (index == 1) {
                               NSString *text = [alert.textFields.firstObject text];
                               [self renamefile:text parentId:parentId parentPath:parentPath fileId:fileId fileName:fileName callBack:callBack controller:controller];
                           }
                       }
                 countOfTextField:1
                   textFieldBlock:^(UITextField *textField, NSInteger index) {
                       
                       NSString * text = CA_H_LAN(@"文件名称");
                       textField.placeholder = text;
                       textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                       
                       NSArray *strArray = [fileName componentsSeparatedByString:@"."];
                       if (strArray.count > 1) {
                           NSMutableArray *mutArray = [NSMutableArray arrayWithArray:strArray];
                           [mutArray removeLastObject];
                           strArray = mutArray;
                       }
                       
                       textField.text = [strArray componentsJoinedByString:@""];
                       [textField performSelector:@selector(selectAllText) withObject:nil afterDelay:0.1];
                       
                   }];
}

+ (void)renamefile:(NSString *)newfileName parentId:(NSNumber *)parentId parentPath:(NSArray *)parentPath fileId:(NSNumber *)fileId fileName:(NSString *)fileName callBack:(void(^)(CA_HNetModel * netModel))callBack controller:(UIViewController *)controller {
    
    NSString *typeStr = @"";
    NSArray *strArray = [fileName componentsSeparatedByString:@"."];
    if (strArray.count > 1) {
        typeStr = [@"." stringByAppendingString:strArray.lastObject];
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:strArray];
        [mutArray removeLastObject];
        strArray = mutArray;
    }
    NSString *subFileName = [strArray componentsJoinedByString:@""];
    
    if ([newfileName isEqualToString:subFileName]) {
        return;
    }
    
    if (newfileName.length==0
        ||
        newfileName.length>=30
        ||
        ![newfileName checkFileTag]) {
        [controller presentAlertTitle:nil message:CA_H_LAN(@"命名规则不符合系统要求，请重新命名") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return ;
    }
    
    if (!(parentId&&parentPath&&fileId)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return ;
    }
    
    NSString *newName = [newfileName stringByAppendingString:typeStr];
    NSDictionary *parameters = @{@"parent_id": parentId,
                                 @"parent_path":parentPath,
                                 @"file_id": fileId,
                                 @"new_name": newName};
    [CA_HNetManager postUrlStr:CA_H_Api_RenameFile parameters:parameters callBack:callBack progress:nil];
}

#pragma mark --- 删除文件

+ (void)deleteFile:(NSNumber *)parentId
            fileId:(NSNumber *)fileId
          callBack:(void(^)(CA_HNetModel * netModel))callBack
        controller:(UIViewController *)controller {
    [controller presentAlertTitle:nil message:CA_H_LAN(@"确认要删除这个文件吗？") buttons:@[CA_H_LAN(@"取消"),@[CA_H_LAN(@"确认删除")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
        if (index == 1) {
            [self deleteFile:parentId fileId:fileId callBack:callBack];
        }
    }];
}

+ (void)deleteFile:(NSNumber *)parentId
            fileId:(NSNumber *)fileId
          callBack:(void(^)(CA_HNetModel * netModel))callBack {
    if (!(parentId&&fileId)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"parent_id":parentId,
                                 @"file_id":fileId
                                 };
    
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteFile parameters:parameters  callBack:callBack progress:nil];
}

#pragma mark --- 新建文件

+ (void)newFile:(NSNumber *)parentId
     parentPath:(NSArray *)parentPath
       fileList:(NSArray *)fileList
       callBack:(void(^)(CA_HNetModel * netModel))callBack {
    
    
    if (!(parentId&&parentPath&&fileList)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"parent_id":parentId,
                                 @"parent_path":parentPath,
                                 @"file_list":fileList
                                 };
    
    [CA_HNetManager postUrlStr:CA_H_Api_CreateFiles parameters:parameters  callBack:callBack progress:nil];
}

@end
